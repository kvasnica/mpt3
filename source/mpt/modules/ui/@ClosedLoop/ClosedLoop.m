classdef ClosedLoop < MPTUIHandle & IterableBehavior
    % Object representation of a closed-loop system
    %
    % Constructor:
    %   loop = ClosedLoop(controller, system)
    
    properties(SetAccess=private)
        controller % Controller
        system % Controlled system
    end
    
    methods
		
        function obj = ClosedLoop(controller, system)
            % Constructor:
            %   loop = ClosedLoop(controller, system)
            
            if nargin == 0
                return
			end
			
			% TODO: check compatibility of number of states/inputs
            obj.system = system;
            obj.controller = controller;
		end
		
		function I = invariantSet(obj, varargin)
			% Computes invariant subset of the closed-loop system
			
			if ~obj.controller.isExplicit()
				error('Only explicit controllers supported.');
			end
			
			I = obj.toSystem().invariantSet(varargin{:});
		end
		
		function out = simulate(obj, x0, N_sim)
			%
			% Simulates the closed-loop system for a given number of steps
			%
			
			error(nargchk(3, 3, nargin));
			
			x0 = x0(:);
			if numel(x0)~=obj.system.nx
				error('The initial state must be a %dx1 vector.', obj.system.nx);
			end

			obj.system.initialize(x0);
			X = x0(:); U = []; Y = []; J = [];
			%X = [x0(:) NaN(obj.system.nx, N_sim)];
			%U = NaN(obj.system.nu, N_sim);
			%Y = NaN(obj.system.ny, N_sim);
			%J = Inf(1, N_sim);
			for k = 1:N_sim
				[u, feasible, openloop] = obj.controller.evaluate(x0);
				if ~feasible
					warning('No control action found at step %d, aborting.', k);
					break
				end
				[x0, y] = obj.system.update(u);
				X = [X x0];
				U = [U u];
				Y = [Y y];
				J = [J openloop.cost];
			end
			out.X = X;
			out.U = U;
			out.Y = Y;
			out.cost = J;
		end

		function out = toSystem(obj)
			% Converts a closed loop system into a LTI/PWA system
			
			if ~obj.controller.isExplicit()
				error('Only explicit controllers supported.');
			end
			
			if numel(obj.controller.optimizer)>1
				error('Overlapping partitions not supported.');
			end
			
			if isa(obj.system, 'LTISystem') && length(obj.controller.optimizer.Set)==1
				% LTI system + linear controller = LTI system with
				% domain restricted to the set where the controller
				% satisfies constraints (not necessarily recursively,
				% though)
				
				feedback = obj.controller.optimizer.Set.getFunction('primal');
				F = feedback.F(1:obj.system.nu, :);
				g = feedback.g(1:obj.system.nu);
				
				% 1) domain of the closed-loop system
				A = []; b = [];
				
				% umin <= F*x+g <= umax
				A = [A; F; -F];
				b = [b; obj.system.u.max-g; -obj.system.u.min+g];
				
				% xmin <= x <= xmax
				A = [A; eye(obj.system.nx); -eye(obj.system.nx)];
				b = [b; obj.system.x.max; -obj.system.x.min];
				
				% ymin <= y <= ymax
				A = [A; obj.system.C; -obj.system.C];
				b = [b; obj.system.y.max; -obj.system.y.min];
				
				D = Polyhedron('A', A, 'b', sanitize_inf(b));
				D = D.intersect(obj.system.domainx);
				
				% 2) dynamics of the closed-loop system
				An = obj.system.A + obj.system.B*F;
				Bn = zeros(obj.system.nx, 0);
				Cn = obj.system.C + obj.system.D*F;
				Dn = zeros(obj.system.ny, 0);
				fn = obj.system.B*g;
				gn = obj.system.D*g;
				
				% 3) construct the LTI system
				out = LTISystem('A', An, 'B', Bn, 'C', Cn, 'D', Dn, ...
					'f', fn, 'g', gn, 'domain', D);
				
			elseif isa(obj.system, 'LTISystem') || isa(obj.system, 'PWASystem')
				% LTI or PWA system + PWA controller = PWA system
				
				R = obj.controller.feedback.Set;
				% TODO: deal with guardU
				Dom = obj.system.domainx;
				
				A = {}; B = {}; C = {}; D = {}; f = {}; g = {};
				Rn = [];
				for i = 1:length(R)
					% extract parameters of the affine control law u=F*x+G
					for j = 1:length(Dom)
						P = R(i).intersect(Dom(j));
						if P.isFullDim
							F = R(i).Func{1}.F(1:obj.system.nu, :);
							G = R(i).Func{1}.g(1:obj.system.nu);
							A{end+1} = obj.system.A + obj.system.B*F;
							B{end+1} = zeros(obj.system.nx, 0);
							f{end+1} = obj.system.B*G;
							C{end+1} = obj.system.C + obj.system.D*F;
							D{end+1} = zeros(obj.system.nu, 0);
							g{end+1} = obj.system.D*G;
							Rn = [Rn, P];
						end
					end
				end
				out = PWASystem('A', A, 'B', B, 'C', C, 'D', D, ...
					'f', f, 'g', g, 'domain', Rn, 'Ts', obj.system.Ts);
			else
				error('Unsupported system.');
			end
			out.x = obj.system.x.copy();
			out.u = SystemSignal;
			out.y = obj.system.y.copy();
		end
    end
end
