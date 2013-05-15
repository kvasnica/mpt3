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
			if ~isa(obj.model, 'LTISystem')
				error('Only LTI systems are supported in this version.');
			end

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
			
			for k = 2:options.maxIterations
				fprintf('New horizon: %d\n', k-1);
				
				% TODO: deal with non-convex terminal sets
				sys.x.terminalSet = ctrl(k-1).optimizer.convexHull;
				
				ctrl(k) = EMPCController(sys, 1);
				if ctrl(k).optimizer.convexHull == ctrl(k-1).optimizer.convexHull
					converged = true;
					break
				end
			end
			if ~converged
				warning('Computation finished without convergence, increase EMinTimeController.maxIterations.');
			end
			obj.stepController = ctrl(startIdx:end);
			
			% put all controllers into one optimizer
			optimizer = [];
			for i = startIdx:length(ctrl)
				opt = ctrl(i).optimizer;
				% step distance to the target is the new cost
				sd = AffFunction(zeros(1, sys.nx), i-1);

				% TODO: copy original cost to 'obj_original' or something
				% like that?
				for j = 1:length(opt.Set)
					opt.Set(j).addFunction(sd, 'obj');
				end
				
				optimizer = [optimizer; opt];
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
