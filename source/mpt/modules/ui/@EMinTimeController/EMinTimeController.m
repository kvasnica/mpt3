classdef EMinTimeController < EMPCController
    % Class representing explicit minimum-time controllers
    %
    % Constructor:
	%   ctrl = EMinTimeCController(model)
	
	properties(SetAccess=protected, Hidden)
		stepController
	end
	
    methods
		
		function out = getName(obj)
			out = 'Explicit minimum-time controller';
		end

        function obj = EMinTimeController(varargin)
            % Constructor:
			%
			% Constructor:
			%   ctrl = RMinTimeCController(model)
            
            if nargin==0
                return
			end

			obj.importUserData(varargin{:});

			obj.N = 1;
			if ~isobject(obj.optimizer)
				obj.construct();
			end
		end
		
        function obj = construct(obj)
            % Constructs the explicit solution

			global MPTOPTIONS
			if isempty(MPTOPTIONS)
				MPTOPTIONS = mptopt;
			end
			options = MPTOPTIONS.modules.ui.EMinTimeController;
			
			% whenever we modify the model, we should work with the model's
			% copy
			sys = obj.model.copy();
			
			if sys.x.hasFilter('terminalSet')
				% use provided terminal set
				fprintf('Using provided terminal state set...\n');

				% after changeset 3f21e875f2ea all imported polyunions must
				% define at least the 'primal' and 'obj' functions
				PU = obj.PolyhedronToPolyUnionHelper(sys.x.terminalSet);
				ctrl = EMPCController(PU);
				ctrl.nu = sys.nu;
				startIdx = 2; % do not add the terminal set into the solution
			elseif ~ismethod(obj.model, 'stabilizingController')
				error('You must specify the terminal state set.');
			else
				% no terminal set given, determine our own
				fprintf('Computing stabilizing terminal controller...\n');
				ctrl = sys.stabilizingController();
				startIdx = 1; % terminal controller will be part of the solution
				sys.x.with('terminalSet');
			end

			if ~sys.x.hasFilter('terminalPenalty')
				sys.x.with('terminalPenalty');
			end
			sys.x.terminalPenalty = sys.x.penalty;

			fprintf('Iterating...\n');
			converged = false;
			previous_targets = ctrl(1).partition.Domain;
			
			for k = 2:options.maxIterations
				fprintf('New horizon: %d\n', k-1);

				opt = [];
				
				% target sets = domain of the controller from previous
				% iteration
				targets = PolyUnion(previous_targets);
				
				% simplify the targets by kicking out sets which are
				% completely covered by other sets
				if targets.Num>1
					n_before = targets.Num;
					targets.reduce();
					fprintf('Target sets: %d (%d discarded)\n', ...
						targets.Num, n_before-targets.Num);
				end
				
				% solve horizon 1 problem for each target set
				new_targets = [];
				for it = 1:targets.Num
					sys.x.terminalSet = targets.Set(it);
					feasible = false;
					try
						ctrl_k_it = EMPCController(sys, 1);
						feasible = true;
					end
					if feasible
						new_targets = [new_targets(:); ctrl_k_it.partition.Domain(:)];
						opt = [opt, ctrl_k_it.optimizer];
					else
						fprintf('Target set #%d: infeasible\n', it);
					end
				end
				
				if isempty(new_targets)
					error('Problem is infeasible.');
				end
				
				% store the new optimizer
				ctrl(k) = ctrl(k-1).copy();
				ctrl(k).optimizer = opt;

				% check convergence
				if new_targets==previous_targets
					converged = true;
					break
				else
					previous_targets = new_targets;
				end
			end
			if ~converged
				warning('Computation finished without convergence, increase EMinTimeController.maxIterations.');
			end
			obj.stepController = ctrl(startIdx:end);
			
			% put all controllers into one optimizer
			optimizer = [];
			for i = startIdx:length(ctrl)
				for k = 1:length(ctrl(i).optimizer)
					opt = ctrl(i).optimizer(k);
					% step distance to the target is the new cost
					sd = AffFunction(zeros(1, sys.nx), i-1);

					% TODO: copy original cost to 'obj_original' or something
					% like that?
					for j = 1:length(opt.Set)
						opt.Set(j).addFunction(sd, 'obj');
					end
					optimizer = [optimizer; opt];
				end
			end
			
			obj.optimizer = optimizer;
		end

		function Y = toYALMIP(obj)
			error('Minimum-time controllers cannot be exported to YALMIP.');
		end
		
		function obj = fromYALMIP(obj, Y)
			error('Minimum-time controllers cannot be imported to YALMIP.');
		end

    end
end
