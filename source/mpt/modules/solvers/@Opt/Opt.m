classdef Opt < handle & matlab.mixin.Copyable
    % Encapsulates data and solutions for LP/QP/pLP/pQP/LCP/pLCP problems
    %
    % opt = Opt(param, value,...)
    % where param/value pairs define LP/QP/pLP/pQP variables
    % J(th) = min 0.5*u'*H*u + (pF*th+f)'*u + th'*Y*th + C*th + c
    %         s.t.  A*u <= b  + pB*th
    %               Ae*u = be + pE*th
    %               lb  <= u <= ub
    % or the LCP/pLCP variables
    % w - M*z = q + Q*th, w,z  >= 0, w'*z = 0
    %
    % opt = Opt(Polyheron P, param, value, ...)
    %  param/value pairs define cost, P defines constraints
    %
    
    properties (GetAccess=public, SetAccess=private)
        % LP/QP/pLP/pQP variables
        % J(th) = min 0.5*u'*H*u + (pF*th+f)'*u + th'*Y*th + C*th + c
        %         s.t.  A*u <= b  + pB*th
        %               Ae*u = be + pE*th
        %               lb  <= u <= ub
        %               Ath*th <= bth
        
        A  = []; b  = []; pB = [];
        Ae = []; be = []; pE = [];
        H  = []; f  = []; pF = [];
        lb = []; ub = [];
        Y = []; C = []; c = [];
        Ath = []; bth = [];
        
        % LCP variables
        % w - M*z = q + Q*th, w,z  >= 0, w'*z = 0
        M  = []; q  = []; Q  = [];
    end
    
    % public properties
    properties (GetAccess = public, SetAccess = public)
        Data  % any user-defined data
    end
    
    
    properties (SetAccess = private)
        n  = 0; % Problem dimension
        m  = 0; % Number of inequalities
        me = 0; % Number of equality constraints
        d  = 0; % Number of parameters
        
        % Problem types given as strings:
        % "LCP" - linear complementarity problem
        % "LP" - linear problem
        % "QP" - quadratic problem
        % "MILP" - mixed integer linear problem
        % "MIQP" - mixed integer quadratic problem

        problem_type = '';
        vartype = ''; % type of variables C-continuous, I-integer, B-binary, S-semicontinuous, N-semiinteger        
        isParametric = false;
        
        recover = []; % Mapping from solved problem to original problem data
        varOrder = [];
        Internal = [];
	end
	
	properties
		solver = ''
	end
    
	methods
		function set.solver(obj, new_solver)
			% Opt.solver setter
			
			if ~ischar(new_solver)
				error('The solver must be a string.');
			end
			obj.solver = upper(new_solver);
		end
	end
	
    methods(Access = public)
        
        % Constructor
        function opt = Opt(varargin)
            if nargin > 0
                if isa(varargin{1},'lmi') || isa(varargin{1},'constraint')
                    % convert from YALMIP data
                    opt = opt.setYalmipData(varargin{:});
                elseif isa(varargin{1},'struct')
                    % convert from MPT2.6 data
                    if isfield(varargin{1},'G') && isfield(varargin{1},'W') && isfield(varargin{1},'E')
                        opt = opt.setMPT26Data(varargin{1});
                    else
                        % call normal constructor
                        opt = opt.setData(varargin{:});
                    end
                else
                    % call normal constructor
                    opt = opt.setData(varargin{:});
                end
                
                % validate
                opt.validate;
                    
            else
                error('Empty problems not supported.');
            end
        end
        
        function K = feasibleSet(obj, arg)
            % Computes the feasible set of a given parametric problem
            %
            % For a parametric problem
            %    min  J(z, x)
            %    s.t. A*z <= b + pB*x
            %         Ae*z = be + pE*x
            % the feasible set K is the polyhedron
            %   K = { x | \exists z s.t. A*z<=b+pB*x, Ae*z=be+pE*x }
            %
            % This method implements two procedures to compute K:
            %   1) if K=prob.feasibleSet() is called, the feasible set is
            %      calculated by projection (can be expensive)
            %   2) if K=prob.feasibleSet(regions) is called with "regions"
            %      being the critical regions of the parametric solution,
            %      then K is constructed as follows:
            %         For each facet of each region do:
            %          a) compute the center of the facet
            %          b) take a small step accross the facet
            %          c) solve the problem for the new point
            %          d) if the problem is infeasible, add the facet to
            %             the feasible set 
            %
            % Syntax:
            %   K = prob.feasibleSet()
            %   K = prob.feasibleSet(method)
            %   K = prob.feasibleSet(regions)
            %
            % Inputs:
            %      prob: parametric problem as an Opt object
            %   regions: (optional) critical regions of the parametric
            %            solution
            %    method: (optional) string identificator of the projection
            %            method to use (see help Polyhedron/projection). By
            %            default we use the 'fourier' method.
            %
            % Output:
            %         K: feasible set as a redundant H-polyhedron
            
            global MPTOPTIONS
            
            error(nargchk(1, 2, nargin));
            if ~obj.isParametric
                error('The problem is not parametric.');
            end
            if nargin==2
                if isa(arg, 'Polyhedron')
                    use_projection = false;
                    regions = arg;
                elseif isa(arg, 'char')
                    use_projection = true;
                    method = arg;
                else
                    error('The input must be either a string or an array of Polyhedron objects.');
                end
            else
                % default projection method
                use_projection = true;
                method = 'fourier';
            end
            
            if use_projection
                % compute the feasible set via projection
                
                if obj.me>0
                    % eliminate equalities, but do it on a copy of the object
                    obj = obj.copy();
                    obj.eliminateEquations();
                end
                
                % construct the polyhedron { (x, z) | A*x<=b+pB*x }
                ZX = Polyhedron([-obj.pB, obj.A], obj.b);
                if ZX.isEmptySet()
                    % the feasible set is empty
                    K = Polyhedron.emptySet(obj.d);
                    return
                end
                
                % the feasible set is given as the projection of ZX onto
                % the parametric space
                K = ZX.projection(1:obj.d, method);
                
            else
                % construct the feasible set via critical regions
                
                % length of step over the facet
                step_size = MPTOPTIONS.rel_tol*10;
                Hf = [];
                t = tic;
                n_fails = 0;
                for i = 1:length(regions)
                    % for each region
                    if toc(t) > MPTOPTIONS.report_period
                        fprintf('progress: %d/%d\n', i, length(regions));
                        t = tic;
                    end
                    for j = 1:length(regions(i).b)
                        % for each facet of the i-th region:
                        % 1) compute a point on the facet
                        lpsol = regions(i).chebyCenter(j);
                        if lpsol.exitflag == MPTOPTIONS.OK
                            % 2) compute the point accross the j-th facet
                            x = lpsol.x + regions(i).A(j, :)'/norm(regions(i).A(j, :)')*step_size;
                            % 3) and solve the problem for the new point
                            qpsol = obj.solve(x);
                            if qpsol.exitflag ~= MPTOPTIONS.OK
                                % 4) infeasible => add this facet to the feasible set
                                Hf = [Hf; regions(i).H(j, :)];
                            end
                        else
                            % numerical problems
                            n_fails = n_fails + 1;
                        end
                    end
                end
                if n_fails > 0
                    fprintf('WARNING: failed to compute points on %d facet(s)\n', n_fails);
                end
                if isempty(Hf)
                    % numerical problems, return R^n
                    K = Polyhedron.fullSpace(regions(1).Dim);
                else
                    K = Polyhedron(Hf(:, 1:end-1), Hf(:, end));
                end
            end
        end
    end
    
%     methods
%         %% SET methods
%         % check if vartype is correct
%         function set.vartype(obj,val)
%             if ~isempty(val)
%                 if isnumeric(val)
%                     % convert to char if it is numeric
%                     val = char(val);
%                 end
%                 if ~isvector(val) || ~ischar(val)
%                     error('The argument must be a vector of strings.');
%                 end
%                 % checking if string is correct
%                 for i=1:length(val)
%                     if ~any(strcmpi(val(i),{'C','I','B','S','N'}))
%                         %C-continuous, I-integer, B-binary, S-semicontinuous, N-semiinteger
%                         error('Given string does not belong to gropu "C-continuous, I-integer, B-binary, S-semicontinuouos, N-semiinteger.');
%                     end
%                 end
%                 
%                 obj.vartype = val;
%             end            
%         end
%         
%     end
    
    methods (Access=protected)
        function U = copyElement(obj)
            % Creates a copy of the union
            %
            %   copy = U.copy()
            
            % Note: matlab.mixin.Copyable.copy() automatically properly
            % copies arrays and empty arrays, no need to do it here.
            % Moreover, it automatically creates the copy of proper class.
            U = copyElement@matlab.mixin.Copyable(obj);

            % we don't know what type of arguments can be put in the future
            % to Internal properties, so we check if a field contains a
            % "copy" method
            if isstruct(obj.Internal)
                nf = fieldnames(obj.Internal);
                for i=1:numel(nf)
                    if ismethod(obj.Internal.(nf{i}),'copy');
                        U.Internal.(nf{i}) = obj.Internal.(nf{i}).copy;
                    end
                end
            else
                if ismethod(obj.Internal,'copy');
                    U.Internal = obj.Internal.copy;
                end
            end
            % we don't know what type of arguments can be stored inside
            % Data, so we check if it contains a "copy" method - then use
            % it to create new object.
            if isstruct(obj.Data)
                nd = fieldnames(obj.Data);
                for i=1:numel(nd)
                    if ismethod(obj.Data.(nd{i}),'copy');
                        U.Data.(nd{i}) = obj.Data.(nd{i}).copy;
                    end
                end
            else
                if ismethod(obj.Data,'copy');
                    U.Data = obj.Data.copy;
                end                
            end
            
        end
 
    end
end
