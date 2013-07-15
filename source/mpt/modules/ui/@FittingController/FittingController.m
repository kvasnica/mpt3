classdef FittingController < EMPCController
    % Class representing explicit fitting-based controllers
    %
    % Constructor:
	%   ctrl = FittingController(explicit_controller)
	%
	% Literature: Takacs, B. - Holaza, J. - Kvasnica, M. - Di Cairano, S.:
	% Nearly-Optimal Simple Explicit MPC Regulators with Recursive
	% Feasibility Guarantees. Submitted to CDC'13.
	
    methods
		
		function out = getName(obj)
			out = 'Explicit fitting-based controller';
		end

        function obj = FittingController(ctrl)
            % Constructor:
			%   ctrl = FittingController(explicit_controller)
            
			if nargin==0
                return
			elseif ~isa(ctrl, 'EMPCController')
				error('Input must be an EMPCController object.');
			elseif numel(ctrl.optimizer)>1
				error('Single optimizer please.');
			end
			
			% copy data from the source object
			obj.importUserData(ctrl.copy());
			% only keep u0
			obj.optimizer.trimFunction('primal', obj.nu);
			obj.N = 1; % to get correct size of the open-loop optimizer
			% TODO: implement a better way
			
			obj.construct();
		end
		
		function construct(obj)
			% Constructs the fitting-based controller
			
			% construct a horizon-1 feedback with set constraints
			model = obj.model.copy();
			Hull = obj.optimizer.convexHull();
			if ~model.x.hasFilter('initialSet')
				model.x.with('initialSet');
			end
			model.x.initialSet = Hull;
			if ~model.x.hasFilter('setConstraint')
				model.x.with('setConstraint');
			end
			model.x.setConstraint = Hull;
			
			if model.x.hasFilter('terminalSet')
				model.x.without('terminalSet');
			end
			fprintf('Computing simple partition...\n');
			N = 1;
			new = EMPCController(model, N);
			if length(new.optimizer)>1
				fprintf('Removing overlaps...\n');
				new.optimizer = new.optimizer.min('obj');
			end
			
			% refine the feedback gains of the new feedback
			fprintf('Refining local feedback laws...\n');
			obj.optimizer = obj.refine(obj.optimizer, new.optimizer, ...
				model.u.min, model.u.max, Hull, ...
				model.A, model.B);
		end
	end
	
	methods (Static, Hidden)
		
        function new = refine(old, new, umin, umax, Cinf, Alti, Blti)
            % Refine feedback law of "new" by minimizing the integral error
            % between the "old" and the "new" feedback
			
			global MPTOPTIONS
			% TODO: check that the feedback law is continuous

			nu = length(umin);
			nx = Cinf.Dim;
			sdpopt = sdpsettings('verbose', 0);
			
			tic
			for i = 1:new.Num

				% we optimize the affine feedback u = alpha_i*x+beta_i
				alpha = sdpvar(nu, nx, 'full');
				beta = sdpvar(nu, 1, 'full');

				% display progress
				if toc > MPTOPTIONS.report_period
					fprintf('%d / %d\n', i, new.Num);
					tic
				end

				% which regions of "old" intersect with new.Set(i) ?
				int_regions = [];
				int_regions_idx = [];
				for j = 1:old.Num
					Qij = new.Set(i).intersect(old.Set(j));
					if Qij.isFullDim()
						int_regions = [int_regions, Qij];
						int_regions_idx = [int_regions_idx, j];
					end
				end
				
				% integral error in the i-th region of "new"
				int_err = 0;
				for j = 1:length(int_regions_idx);
					
					% feedback law in "old"
					feedback_old = old.Set(int_regions_idx(j)).Functions('primal');
					Fj = feedback_old.F;
					gj = feedback_old.g;
					
					% fitting error
					Equad = Fj'*Fj + alpha'*alpha - 2*Fj'*alpha;
					Elin = 2*(gj'*Fj + beta'*alpha - gj'*alpha - beta'*Fj);
					Econst = gj'*gj + beta'*beta - 2*gj'*beta;
					
					% integrate the fitting error over the intersection
					Efun = QuadFunction(Equad, Elin, Econst);
					int_regions(j).addFunction(Efun, 'error');
					int_err = int_err + int_regions(j).integrate('error');
				end
				
				% impose invariance constraints
				CON = [];
				V = new.Set(i).V;
				tol = sdpvar(1, 1);
				CON = CON + [ tol >= 0 ];
				for j = 1:size(V, 1)
					x = V(j, :)';
					
					%   umin <= uaprx <= umax
					CON = CON + [ -tol+umin <= (alpha*x + beta) <= umax+tol ];
					
					% invariance:
% 					%   A*x+B*u \in \Cinf
% 					if ~iscell(Alti)
% 						CON = CON + [ Cinf.A*(Alti*x + Blti*(alpha*x + beta)) <= Cinf.b+tol ];
% 					end
				end

				% optimize for alpha and beta
				info = solvesdp(CON, int_err + 1e6*tol, sdpopt);
				if info.problem~=0 && info.problem~=-1
					error(info.info)
				elseif info.problem==-1
					fprintf('WARNING: unknown error in solver.\n');
				end
				
				% store the updated feedback
				feedback_new = AffFunction(double(alpha), double(beta));
				new.Set(i).addFunction(feedback_new, 'primal');
			end
		end

    end
end
