classdef PWASystem < AbstractSystem
    % Object representation of a PWA system
    %
    % To import data from sysStruct/probStruct:
    %   s = PWASystem(sysStruct, probStruct)

    properties(SetAccess=protected)
        A % Matrices of the state-update equation x(t+Ts)=A_i*x(t)+B_i*u(t)+f_i
        B % Matrices of the state-update equation x(t+Ts)=A_i*x(t)+B_i*u(t)+f_i
        C % Matrices of the output equation y(t)=C_i*x(t)+D_i*u(t)+g_i
        D % Matrices of the output equation y(t)=C_i*x(t)+D_i*u(t)+g_i
        f % Matrices of the state-update equation x(t+Ts)=A_i*x(t)+B_i*u(t)+f_i
        g % Matrices of the output equation y(t)=C_i*x(t)+D_i*u(t)+g_i
        ndyn % Number of local dynamics
	end

	properties(SetAccess=private, GetAccess=private, Hidden)
		modes % local affine modes as an array of LTISystem
		polyunion % state-update and output equations as a PolyUnion object
	end
            
	methods(Hidden)
		% implementation of abstract methods
		
		% no validation in these functions! it was already performed in
		% AbstractSystem/update() and output()
		
		function xn = update_equation(obj, x, u)
			% returns the state update
			
			% use the first-region tiebreak
			xn = obj.polyunion.feval([x; u], 'update', 'tiebreak', @(q) 0);
		end
		
		function y = output_equation(obj, x, u)
			% output equation

			% use the first-region tiebreak
			y = obj.polyunion.feval([x; u], 'output', 'tiebreak', @(q) 0);
		end
		
		function out = has_feedthrough(obj)
			% feedthrough indication. must return true if the system has
			% direct feedthrough, false otherwise

			out = (nnz(cat(2, obj.D{:}))~=0);
		end
	end

    methods
        
        function obj = PWASystem(varargin)
            % Constructor for PWA systems
            %
            %   x^+ = A{i}*x + B{i}*u + f{i}   if   [x; u] \in P(i)
            %     y = C{i}*x + D{i}*u + g{i}
            % 
            % s = PWASystem('A', A, 'B', B, 'C', C, 'D', D, 'domain', P)
			%
			% To import from a sysStruct structure:
            %   s = PWASystem(sysStruct)

            
            if nargin == 0
                return
			end
            
			if nargin==1 && isstruct(varargin{1})
                % import from sysStruct
                S = mpt_verifySysStruct(varargin{1});
                P = [];
                for i = 1:length(S.guardX)
                    P = [P, Polyhedron('A', [S.guardX{i}, S.guardU{i}], ...
                        'b', S.guardC{i}).minHRep];
                end
                S.domain = P;
				
			elseif nargin==1 && isa(varargin{1}, 'MLDSystem')
				% convert MLD to PWA
				M = varargin{1};
				obj = M.toPWA();
				return
				
			elseif nargin==1 && isa(varargin{1}, 'LTISystem')
				% convert array of LTI systems into PWA
				
				lti = varargin{1};
				S = [];
				S.A = cell(1, numel(lti));
				S.B = cell(1, numel(lti));
				S.f = cell(1, numel(lti));
				S.C = cell(1, numel(lti));
				S.D = cell(1, numel(lti));
				S.g = cell(1, numel(lti));
				
				% check that all systems have identical dimensions
				nx = cell(1, numel(lti));
				nu = cell(1, numel(lti));
				ny = cell(1, numel(lti));
				[nx{:}] = lti.nx; nx = cat(2, nx{:});
				[nu{:}] = lti.nu; nu = cat(2, nu{:});
				[ny{:}] = lti.ny; ny = cat(2, ny{:});
				if any(diff(nx))
					error('All systems must have identical state dimensions.');
				end
				if any(diff(nu))
					error('All systems must have identical input dimensions.');
				end
				if any(diff(ny))
					error('All systems must have identical output dimensions.');
				end
				
				% check that all systems have identical sampling time
				S.Ts = lti(1).Ts;
				for i = 2:numel(lti)
					if ~isequal(lti(i).Ts, S.Ts)
						error('All systems must have identical sampling time.');
					end
				end

				% put matrices into a cell array
				for i = 1:numel(lti)
					S.A{i} = lti(i).A;
					S.B{i} = lti(i).B;
					S.f{i} = lti(i).f;
					S.C{i} = lti(i).C;
					S.D{i} = lti(i).D;
					S.g{i} = lti(i).g;
				end
				
				% warn user that constraints will be ignored
				for i = 1:numel(lti)
					if hasFilter(lti(i).x, 'min') || ...
							hasFilter(lti(i).x, 'max') || ...
							hasFilter(lti(i).u, 'min') || ...
							hasFilter(lti(i).u, 'max') || ...
							hasFilter(lti(i).y, 'min') || ...
							hasFilter(lti(i).y, 'max')
						% TODO: set constraints automatically
						fprintf('State/input/output constraints not imported, set them manually afterwards.\n');
						break;
					end
				end
				
				% import domain
				S.domain = [];
				for i = 1:numel(lti)
					S.domain = [S.domain; lti(i).domain];
				end
				
			elseif nargin==1
				error('Unrecognized import source.');
			
			else
				% import from option/value pairs
				ip = inputParser;
				ip.KeepUnmatched = false;
				ip.addParamValue('A', [], @iscell);
				ip.addParamValue('B', [], @iscell);
				ip.addParamValue('f', [], @iscell);
				ip.addParamValue('C', [], @iscell);
				ip.addParamValue('D', [], @iscell);
				ip.addParamValue('g', [], @iscell);
				ip.addParamValue('domain', [], @validate_polyhedron);
				ip.addParamValue('Ts', 1, @(x) isa(x, 'double') && numel(x)==1 && x>=0);
				ip.addParamValue('sysStruct', [], @isstruct);
				ip.parse(varargin{:});
				S = ip.Results;
			end

            obj.A = S.A;
            obj.B = S.B;
            obj.f = S.f;
            obj.C = S.C;
            obj.D = S.D;
            obj.g = S.g;
            obj.Ts = S.Ts;
			
			% TODO: check that domains in the x-u space do not overlap
            obj.domain = S.domain;

            obj.nx = size(obj.A{1}, 2);
            obj.nu = size(obj.B{1}, 2);
            obj.ny = size(obj.C{1}, 1);
            obj.ndyn = length(obj.A);

			obj.domainx = [];
			for i = 1:length(obj.domain)
				% TODO: remove the hard-coded 'fourier' method once
				% Polyhedron/projection is reliable
				dx = obj.domain(i).projection(1:obj.nx, 'fourier').minHRep();
				obj.domainx = [obj.domainx dx];
			end
            
            if isempty(obj.f)
                obj.f = zeros(obj.nx, 0);
            end
            if isempty(obj.g)
                obj.g = zeros(obj.nx, 0);
            end

            x = SystemSignal(obj.nx);
            x.name = 'x';
            x.setKind('x');
            obj.addComponent('x', x);
            
            u = SystemSignal(obj.nu);
            u.name = 'u';
            u.setKind('u');
            obj.addComponent('u', u);
			if isfield(S, 'Uset')
				% mark inputs as binary
				obj.u.with('binary');
				obj.u.binary = find(cellfun(@(x) isequal(x, [0 1]), S.Uset));
			end

			y = SystemSignal(obj.ny);
			y.name = 'y';
			y.setKind('y')
			obj.addComponent('y', y);
            
            % create additional binary selectors for the PWA dynamics
            d = SystemSignal(obj.ndyn);
			d.addFilter('binary');
			d.binary = true;
            d.name = 'd';
            d.setKind('d');
            obj.addComponent('d', d);
            
            if nargin==1
                % import constraints from sysStruct
                obj.importSysStructConstraints(S);
			end
			
			% store the state-update and output functions as a PolyUnion
			P = Polyhedron(obj.domain); % create copy
			for i = 1:obj.ndyn
				update = AffFunction([obj.A{i}, obj.B{i}], obj.f{i});
				output = AffFunction([obj.C{i}, obj.D{i}], obj.g{i});
				P(i).addFunction(update, 'update');
				P(i).addFunction(output, 'output');
			end
			obj.polyunion = PolyUnion(P);
			
			% store the individual modes as an array of LTISystems
			modes = [];
			for pwa_index = 1:obj.ndyn
				lti = LTISystem('A', obj.A{pwa_index}, 'B', obj.B{pwa_index}, ...
					'C', obj.C{pwa_index}, 'D', obj.D{pwa_index}, ...
					'f', obj.f{pwa_index}, 'g', obj.g{pwa_index}, ...
					'domain', obj.domain(pwa_index), 'Ts', obj.Ts);
				lti.x = obj.x;
				lti.u = obj.u;
				lti.y = obj.y;
				modes = [modes, lti];
			end
			obj.modes = modes;
		end
        
		function out = toLTI(obj, pwa_index)
			% Converts dynamics indexed by "pwa_index" to an LTI system
			
			if pwa_index<1 || pwa_index>obj.ndyn
				error('Index out of range.');
			end
			out = obj.modes(pwa_index);
		end
		
		function [S, SN, dyn, dynN] = reachableSet(obj, varargin)
			% Computes the forward/backwards reachable N-step set

			ip = inputParser;
			ip.KeepUnmatched = false;
			ip.addParamValue('direction', 'forward', @ischar);
			ip.addParamValue('N', 1, @isnumeric);
            ip.addParamValue('X', ...
				obj.x.boundsToPolyhedron(), ...
				@validate_polyhedron);
            ip.addParamValue('U', ...
				obj.u.boundsToPolyhedron(), ...
				@validate_polyhedron);
			ip.addParamValue('merge', true, @islogical);
			ip.parse(varargin{:});
			options = ip.Results;

			if numel(options.U)~=1
				error('Input constraints must be a single polyhedron.');
			end
			if any(options.X.isEmptySet)
				error('State constraints must not be empty.');
			end
			if obj.nu>0 && options.U.isEmptySet()
				error('Input constraints must not be empty.');
			end
			if any(arrayfun(@(x) x.Dim~=obj.nx, options.X))
				error('State constraints must be a polyhedron in %dD.', obj.nx);
			end
			if obj.nu>0 && options.U.Dim~=obj.nu
				error('Input constraints must be a polyhedron in %dD.', obj.nu);
			end

			X = options.X*options.U;
			SN = {}; dynN = {};
			for n = 1:options.N
				Xp = []; dyn = [];
				for j = 1:obj.ndyn
					lti = obj.toLTI(j);
					XD = X.projection(1:obj.nx);
					R = lti.reachableSet('N', 1, ...
						'direction', options.direction, ...
						'X', XD, 'U', options.U);
					% is the union of "R" convex?
					if numel(R)>1
						H = PolyUnion(R);
						if H.isConvex
							R = H.convexHull;
						elseif options.merge
							R = PolyUnion(R).merge().Set;
						end
					end
					Xp = [Xp, R];
					dyn = [dyn j*ones(1, numel(R))];
				end
				X = Xp*options.U;
				SN{n} = Xp;
				dynN{n} = dyn;
			end
			S = SN{end};
			dyn = dynN{end};
		end

		function [X, dyn] = invariantSet(obj, varargin)
			% Computes invariant set of the system
			

			global MPTOPTIONS
			if isempty(MPTOPTIONS)
				MPTOPTIONS = mptopt;
			end
			options = MPTOPTIONS.modules.ui.invariantSet;

			ip = inputParser;
			ip.KeepUnmatched = false;
            ip.addParamValue('maxIterations', ...
				options.maxIterations, @isscalar);
            ip.addParamValue('X', ...
				obj.domainx, ...
				@validate_polyhedron);
            ip.addParamValue('U', ...
				obj.u.boundsToPolyhedron(), ...
				@validate_polyhedron);
			ip.addParamValue('merge', true, @islogical);
			ip.parse(varargin{:});
			options = ip.Results;

			if numel(options.U)~=1
				error('Input constraints must be a single polyhedron.');
			end
			if any(options.X.isEmptySet)
				error('State constraints must not be empty.');
			end
			if obj.nu>0 && options.U.isEmptySet()
				error('Input constraints must not be empty.');
			end
			if any(arrayfun(@(x) x.Dim~=obj.nx, options.X))
				error('State constraints must be a polyhedron in %dD.', obj.nx);
			end
			if obj.nu>0 && options.U.Dim~=obj.nu
				error('Input constraints must be a polyhedron in %dD.', obj.nu);
			end

			Xo = options.X;
			U = options.U;
			converged = false;
			for i = 1:options.maxIterations
				fprintf('Iteration %d...\n', i);
				[X, ~, dyn] = obj.reachableSet('X', Xo, 'U', U, ...
					'direction', 'backward', ...
					'merge', true);
				X = X.intersect(obj.x.boundsToPolyhedron);
				if X==Xo
					converged = true;
					break
				else
					Xo = X;
				end
			end
			if ~converged
				warning('Computation finished without convergence.');
			end
		end

        function C = constraints(obj, k)
            % Convert LTI model into YALMIP constraints
            
            % constraints on variables
            C = constraints@AbstractSystem(obj);
            % add the PWA dynamics constraints
            x = obj.x.var;
            u = obj.u.var;
            y = obj.y.var;
            d = obj.d.var;
            for k = 1:obj.Internal.system.N
                if obj.nx > 0
                    for dyn = 1:obj.ndyn
                        C = C + [ implies(d(dyn, k), ...
                            x(:, k+1) == obj.A{dyn}*x(:, k) + obj.B{dyn}*u(:, k) + obj.f{dyn}) ];
                    end
                end
                if obj.ny > 0
                    for dyn = 1:obj.ndyn
                        C = C + [ implies(d(dyn, k), ...
                            y(:, k) == obj.C{dyn}*x(:, k) + obj.D{dyn}*u(:, k) + obj.g{dyn}) ];
                    end
                end
                for dyn = 1:obj.ndyn
					if isa(obj.domain(dyn), 'polytope')
						[H, K] = double(obj.domain(dyn));
					else
						H = obj.domain(dyn).A;
						K = obj.domain(dyn).b;
						H = [H; obj.domain(dyn).Ae; -obj.domain(dyn).Ae];
						K = [K; obj.domain(dyn).be; -obj.domain(dyn).be];
					end
                    C = C + [ implies(d(dyn, k), H*[x(:, k); u(:, k)] <= K) ];
                end
                C = C + [ sum(d(:, k)) == 1 ];
            end
        end
        
    end
end
