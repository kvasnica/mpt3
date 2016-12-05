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
            %            default we use the 'ifourier' method.
            %
            % Output:
            %         K: feasible set as a redundant H-polyhedron
            
            global MPTOPTIONS
            
            narginchk(1, 2);
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
                method = 'ifourier';
            end
            
            if use_projection
                % compute the feasible set via projection
                
                if isequal(lower(obj.problem_type), 'lcp') && ...
                        ~isfield(obj.Internal, 'constraints')
                    % This is a pLCP that was defined manually
                    %
                    % LCP constraints:
                    %   I*w - M*z = q + Q*x
                    %   w >= 0, z >= 0
                    %   Ath*x <= bth
                    
                    [nw, nz] = size(obj.M);
                    nb = length(obj.bth);
                    % y = [x; w; z]
                    Ae = [-obj.Q, eye(nw), -obj.M];
                    be = obj.q;
                    A = [obj.Ath, zeros(nb, nw+nz); ...
                        zeros(nw, obj.d), -eye(nw), zeros(nw, nz); ...
                        zeros(nz, obj.d+nw), -eye(nz)];
                    b = [obj.bth; zeros(nw+nz, 1)];
                    ZX = Polyhedron('Ae', Ae, 'be', be, 'A', A, 'b', b);

                else
                    % LP/QP constraints:
                    %     A*z <= b + pB*x
                    %    Ae*z == be + pE*x
                    %   Ath*x <= bth
                    
                    if isfield(obj.Internal, 'constraints')
                        % This is a pLCP that was generated by
                        % Opt/qp2lcp(). Convert it to the original pQP
                        % formulation to reduce the number of variables
                        obj = Opt(obj.Internal.constraints);
                    end
                    
                    if obj.me>0
                        % eliminate equalities, but do it on a copy of the object
                        obj = obj.copy();
                        obj.eliminateEquations();
                    end
                    
                    % construct the polyhedron 
                    % { (x, z) | A*x<=b+pB*x, Ath*x<=bth }
                    ZX = Polyhedron([-obj.pB, obj.A; ...
                        obj.Ath, zeros(length(obj.bth), obj.n)], ...
                        [obj.b; obj.bth]);
                end
                
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
                    % make sure we have the minimal H-representation
                    % (we do redundancy elimination here since it can be
                    % costly in high dimensions; hence we want to give the
                    % uer an appropriate progress report)
                    regions(i).minHRep();
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
        
        function obj = minHRep(obj)
            % Removes redundant inequalities
            %
            % Given a parametric optimization problem with constraints
            %      A*z <= b + pB*theta
            % this method removes the redundant inequalities.
            
            assert(obj.d>0, 'The problem is not parametric.');
            
            P = Polyhedron([obj.A, -obj.pB], obj.b);
            P.minHRep();
            obj.A = P.A(:, 1:obj.n);
            obj.pB = -P.A(:, obj.n+1:end);
            obj.b = P.b;
            obj.m = length(obj.b);
        end
        
        function CR = getRegion(obj, A, options)
            % Constructs a critical region, the optimizers, and the cost function
            %
            % Syntax:
            %   CR = pqp.getRegion(A)
            %   CR = pqp.getRegion(A)
            %
            % Inputs:
            %   pqp: pqp problem as an instance of the Opt class
            %     A: incides of the active inequalities
            %
            % Output:
            %     R: critical region as a Polyhedron object with functions "primal"
            %        and "obj"

            narginchk(2, 3);
            assert(isequal(obj.problem_type, 'QP'), 'Only pQPs are supported.');
            assert(obj.d>0, 'The problem must have parameters.');
            assert(obj.me==0, 'Equalities are not supported.');
            if nargin<3
                options = [];
            end
            options = mpt_defaultOptions(options, 'regionless', false, 'pqp_with_equalities', obj);
            
            % special notion for no active constraints
            if isequal(A, 0)
                A = [];
            end
            
            % extract active sets
            Ga = obj.A(A, :);
            Ea = obj.pB(A, :);
            wa = obj.b(A, :);
            
            % extract non-active sets
            all = 1:obj.m;
            N  = all(~ismembc(all, A));
            Gn = obj.A(N, :);
            En = obj.pB(N, :);
            wn = obj.b(N, :);
            
            % optimal dual variables
            alpha_1 = -Ga/obj.H*obj.pF - Ea;
            alpha_2 = -Ga/obj.H*Ga';
            beta    = -Ga/obj.H*obj.f - wa;
            
            % dual variables are an affine function of the parameters
            alpha_L = -inv(alpha_2)*alpha_1;
            beta_L  = -inv(alpha_2)*beta;
            
            % optimizer is an affine function of the parameters
            alpha_x = -obj.H\obj.pF - obj.H\Ga'*alpha_L;
            beta_x  = -obj.H\obj.f - obj.H\Ga'*beta_L;
            
            % Critical region
            crH = [Gn*alpha_x - En; -alpha_L];
            crh = [-Gn*beta_x + wn; beta_L];
            if ~options.regionless
                CR = Polyhedron(crH, crh);
                if ~CR.isFullDim()
                    % lower-dimensional region
                    CR = [];
                    return
                end
            else
                % FIXME: IPDPolyhedron must either take the object with
                % equalities, or optimizer must be projected on them
                %CR = IPDPolyhedron(size(crH, 2), options.pqp_with_equalities);
                CR = IPDPolyhedron(size(crH, 2), obj);
                CR.setInternal('Empty', false);
            end
            
            if ~options.regionless
                % remove redundant constraints
                CR.minHRep();
            end

            % cost function
            % TODO: check this
            Jquad = 0.5*alpha_x'*obj.H*alpha_x + obj.pF'*alpha_x + obj.Y;
            Jaff = beta_x'*obj.H*alpha_x + beta_x'*obj.pF + obj.f'*alpha_x + obj.C;
            Jconst = 0.5*beta_x'*obj.H*beta_x + obj.f'*beta_x + obj.c;
            J = QuadFunction(Jquad, Jaff, Jconst);
            
            if ~isempty(obj.recover)
                % Project primal optimizer back on equalities
                Lprimal = obj.recover.Y*[alpha_x, beta_x] + obj.recover.th;
                alpha_x = Lprimal(:, 1:end-1);
                beta_x = Lprimal(:, end);
            end
            % primal optimizer
            if ~isempty(obj.varOrder) && ~isempty(obj.varOrder.requested_variables)
                % extract only requested variables from the primal
                % optimizer
                alpha_x = alpha_x(obj.varOrder.requested_variables, :);
                beta_x = beta_x(obj.varOrder.requested_variables);
            end
            z = AffFunction(alpha_x, beta_x);
            % lagrange multipliers: aL*x+bL
            aL = zeros(size(obj.pB));
            bL = zeros(size(obj.b));
            aL(A, :) = alpha_L;
            bL(A) = beta_L;
            L = AffFunction(aL, bL);
            
            % attach functions
            CR.addFunction(z, 'primal');
            CR.addFunction(J, 'obj');
            CR.addFunction(L, 'dual-ineqlin');
            CR.Data.Active = A;
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
                    x = obj.Internal.(nf{i});
                    if isobject(x) && ismethod(x, 'copy');
                        U.Internal.(nf{i}) = x.copy();
                    end
                end
            else
                if isobject(obj.Internal) && ismethod(obj.Internal,'copy');
                    U.Internal = obj.Internal.copy();
                end
            end
            % we don't know what type of arguments can be stored inside
            % Data, so we check if it contains a "copy" method - then use
            % it to create new object.
            if isstruct(obj.Data)
                nd = fieldnames(obj.Data);
                for i=1:numel(nd)
                    x = obj.Data.(nd{i});
                    if isobject(x) && ismethod(x,'copy');
                        U.Data.(nd{i}) = x.copy();
                    end
                end
            else
                if isobject(obj.Data) && ismethod(obj.Data,'copy');
                    U.Data = obj.Data.copy;
                end                
            end
            
        end
 
    end
end
