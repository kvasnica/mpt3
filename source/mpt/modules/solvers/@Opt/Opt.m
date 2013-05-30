classdef Opt < handle
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
    
end
