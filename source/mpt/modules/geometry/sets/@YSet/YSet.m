classdef YSet < ConvexSet
  %%
  % YSet
  %
  % Represents a set described by a list of YALMIP constraints.
  %
  %
  
  %%
  properties(SetAccess = private)
    constraints; % YALMIP constraints
    vars;        % YALMIP variables
  end
  
  properties(SetAccess = public)
    opts = sdpsettings('verbose', 0,'allownonconvex',0);        % YALMIP default options
  end
  
  properties(SetAccess = private, Hidden = true)
    extr   = []; % YALMIP optimizer object for computing extreme points
    maxsep = []; % YALMIP optimizer object for projecting points
    alpha = sdpvar(1); % Used in shoot
    x0 = [];     % Used in extreme
  end
  
  %%
  methods

    %% Constructor
    function obj = YSet(vars, constraints, opts)
      %
      % obj = YSet(vars, constraints, opts)
      %
      % Constructor with default YALMIP options.<p>
      %
      % Note that the object can involve many YALMIP variables that are not listed in vars.
      % For example, one can operate directly on the projection of an object without first
      % projecting that object.
      %
      % @param vars The YALMIP variables involved in this object.
      % @param constraints The YALMIP constraints describing this object.
      %
      
      error(nargchk(2,3,nargin));

% Prepared for future, if we want to copy YSet objects.
% The problem here is that simple reassigning of sdpvar data still refers
% to the same variable. The new variables and constraints must be recreated
% again, using sdpvar/binvar and set commands.
%       if nargin==1
%           % copy constructor
%           if ~isa(vars,'YSet')
%               error('The input argument must be object of "YSet" class, in order to create a copy of the object.');
%           end
%           % deal with arrays
%           if numel(vars)>1
%               for i=1:numel(vars)
%                   obj(i) = YSet(vars(i));
%               end
%               return;
%           end
%           
%           if numel(vars)==0
%               error('The input argument must be non-empty.');
%           end
%                     
%           obj = YSet(vars.vars,vars.constraints, vars.opts);
% 			  keys = obj.Functions.keys;
% 			  values = obj.Functions.values;
% 			  for j = 1:numel(keys)
% 				  obj.Functions(keys{j}) = values{j};
% 			  end
%           
%           % copy internal data field by field, otherwise it will refer to the same data
%           if isstruct(vars.Internal)
%               nf = fieldnames(vars.Internal);
%               for i=1:numel(nf)
%                   obj.Internal.(nf{i}) = vars.Internal.(nf{i});
%               end
%           else
%               obj.Internal = vars.Internal;
%           end
%           % copy internal data field by field, otherwise it will refer to the same data
%           if isstruct(vars.Data)
%               nf = fieldnames(vars.Data);
%               for i=1:numel(nf)
%                   obj.Data.(nf{i}) = vars.Data.(nf{i});
%               end
%           else
%               obj.Data = vars.Data;
%           end          
%           return
%       end
      
      if ~isvector(vars)
          error('Variables must be provided as vectors only.');
      end
      if ~isa(vars, 'sdpvar'),
          error('YALMIP variables must be given as "sdpvar" object.');
      end

      if ~(isa(constraints, 'lmi') || isa(constraints, 'constraint'))
          error('YALMIP constraints must be given as "lmi" object.');
      end
      
      % assign arguments
      obj.constraints = constraints;
      obj.vars = vars;
	  % initialized the function storage
	  obj.Functions = containers.Map;
      
      if nargin > 2,
          if ~isa(opts,'struct')
              error('Options must be provided in a struct format, given by YALMIP "sdpsettings".');
          else
             % check the fields of sdpsettings
             fn = fieldnames(sdpsettings);
             for i=1:numel(fn)
                if ~isfield(opts,fn{i})
                    error('The field "%s" is missing in the options format.',fn{i});
                end
             end              
          end
          % for any supplied option we must always check for convexity
          obj.opts = sdpsettings(opts,'allownonconvex',0);
      end

      obj.Dim = numel(obj.vars);
      
      % check if the dimension matches with the dimension of the variables
      % in the constraint set
      
      % generate null point and assign
      v = zeros(size(obj.vars)); 
      s = yalmip('getsolution');
      assign(obj.vars,v);
      % check residuals
      r = checkset(obj.constraints);
      if any(isnan(r))
          error('Dimension mismatch between the provided variables and the variables in the constraint set.');
      end
      yalmip('setallsolution',s);
          

                  
      % Prep extr function
      % Create a model in YALMIPs low level format
      % All we change later is the cost vector
      [model,recoverdata,diagnostic,internalmodel] = export(obj.constraints,[],obj.opts,[],[],0);

      if ~isempty(diagnostic)
          % check convexity
          if diagnostic.problem==14
              error('Provided YALMIP constraints build non-convex set. Only convex set are allowed.');
          end
          % there may be another problem
          error('An error occured when exporting YALMIP model: "%s"', diagnostic.info);
      end

      if isempty(internalmodel)
        error('Could not create model for inner approximation.');
      end

      internalmodel.options.saveduals = 0;
      internalmodel.getsolvertime = 0;
      internalmodel.options.dimacs = 0;
      
      localindex = [];
      for i = 1:numel(obj.vars)
        localindex = [localindex find(ismember(recoverdata.used_variables,getvariables(obj.vars(i))))];
      end
      
      obj.extr.model = internalmodel;
      obj.extr.local = localindex;
      
      % Prep maxsep function
      obj.x0 = sdpvar(obj.Dim,1,'full');
      obj.maxsep = optimizer(obj.constraints, 0.5*(obj.x0-obj.vars(:))'*(obj.x0-obj.vars(:)),obj.opts,obj.x0,obj.vars);

      
    end
        
  end
  
end

