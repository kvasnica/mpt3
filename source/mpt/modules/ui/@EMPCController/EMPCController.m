classdef EMPCController < AbstractController
    % Class representing explicit MPC controllers
    %
    % Constructor:
	%   ctrl = EMPCController(model, N)
	%   ctrl = EMPCController(MPCController)

    properties(Dependent=true, SetAccess=protected, Transient=true)
		partition
		feedback
		cost
	end
    
    methods

		function out = isExplicit(obj)
            % True for explicit controllers
            out = true;
		end
		
		function out = getName(obj)
			out = 'Explicit MPC controller';
		end

		function obj = EMPCController(varargin)
            % Constructor:
			%
			%   ctrl = EMPCController(model, N)

			if nargin==0
                return
			end

			obj.importUserData(varargin{:});
			
			if ~isobject(obj.optimizer)
				obj.construct();
			end
		end
		
		function out = nr(obj)
			% Returns total number of regions
			
			% Supports multiple optimizers
			if isobject(obj.optimizer)
				n = cell(1, numel(obj.optimizer));
				[n{:}] = obj.optimizer.Num;
				out = sum([n{:}]);
			else
				out = 0;
			end
		end
		
		function obj = toInvariant(in)
			% Computes the invariant subset of the controller
			
			if nargout==0
				% replace original controller
				obj = in;
			else
				% create a new controller
				obj = in.copy();
			end
			
			% create the closed-loop model
			CL = ClosedLoop(obj, obj.model).toSystem();
			
			% compute invariant subset
			[I, dynamics] = CL.invariantSet();
			
			% create new explicit solution
			for j = 1:length(obj.optimizer.Set(1).Func)
				for i = 1:length(I)
					I(i).copyFunctionsFrom(obj.optimizer.Set(dynamics(i)));
				end
			end
			
			% TODO: propagate properties? (Overlaps, Bounded, FullDim)
			obj.optimizer = PolyUnion('Set', I);
			
		end
		
        function obj = construct(obj)
            % Constructs the explicit solution

			% make sure the prediction horizon was provided
			error(obj.assert_controllerparams_defined);

			if isempty(obj.yalmipData)
				Y = obj.toYALMIP();
			else
				Y = obj.yalmipData;
			end
			% TODO: remove the debug flag for beta
			options = sdpsettings('debug', 1);
			
			speedhack = false;

			if speedhack
				% bypass Opt() since it's so slow now (Aug 2012)
				sol = solvemp(Y.constraints, Y.objective, options, ...
					Y.variables.x(:, 1), Y.variables.u(:));
				if isempty(sol) || isempty(sol{1})
					error('Problem is infeasible.');
				end
				% convert to MPT3
				res.xopt = mpt_mpsol2pu(sol);
			else
				% standard way via Opt

				% TODO: Opt() should allow MILP/MIQP problems to be constructed
				% even if MPLP/MPQP parametric solvers are chosen
				problem = Opt(Y.constraints, Y.objective, ...
					Y.variables.x(:, 1), Y.variables.u(:));
				
				if isequal(problem.problem_type,'MILP') || ...
						isequal(problem.problem_type, 'MIQP')
					% use YALMIP for pMILP/pMIQP problems
					sol = solvemp(Y.constraints, Y.objective, options, ...
						Y.variables.x(:, 1), Y.variables.u(:));
					if isempty(sol) || isempty(sol{1})
						error('Problem is infeasible.');
					end
					% convert to MPT3
					res.xopt = mpt_mpsol2pu(sol);
				else
					res = problem.solve;
				end
			end
            obj.optimizer = res.xopt;
		end
        
		function out = get.feedback(obj)
			% Returns the feedback law
			
			out = obj.optimizer.getFunction('primal');
		end
		
		function out = get.cost(obj)
			% Returns the cost function
			
			out = obj.optimizer.getFunction('obj');
		end
		
		function out = get.partition(obj)
			% Returns the polyhedral partition

			if numel(obj.optimizer)==1
				% single optimizer, copy it and remove functions
				out = obj.optimizer.copy();
				out.removeAllFunctions();
			else
				% multiple optimizers, concatenate regions together
				P = [];
				for i = 1:length(obj.optimizer)
					P = [P; Polyhedron(obj.optimizer(i).Set)];
				end
				out = PolyUnion('Set', P.removeAllFunctions);
			end
		end
		
		% 		function obj = set.optimizer(obj, optimizer)
		% 			% Splits the optimizer into feedback/cost/partition for fast
		% 			% access
		%
		% 			disp('Optimizer set.');
		% 			obj.optimizer = optimizer;
		%
		% 			obj.feedback = optimizer.getFunction('primal');
		% 			obj.cost = optimizer.getFunction('obj');
		% 		end
			
		% 		function h = plot(obj)
		% 			% Plots partition of the controller
		%
		% 			h = obj.optimizer.plot();
		% 			if nargout==0
		% 				clear h
		% 			end
		% 		end
		
		function [u, feasible, openloop] = evaluate(obj, xinit)
            % Evaluates the explicit solution for a given point
			%
			% u = controller.evaluate(x0) evaluates the explicit MPC
			% solution and returns the optimal control input associated to
			% point "x0". If "x0" is outside of the controller's domain,
			% "u" will be NaN.
			%
			% [u, feasible] = controller.evaluate(x0) also returns a
			% feasibility boolean flag.
			%
			% [u, feasible, openloop] = controller.evaluate(x0) also
			% returns the full open-loop optimizer in "openloop.U" and the
			% optimal cost in "openloop.cost". Moreover, "openloop.X" and
			% "openloop.Y" will be set to NaN. This is due to the fact that
			% storing open-loop predictions of states and outputs in the
			% explicit solution would considerably increase its size.

			% TODO: point location should be a method of PolyUnion

			% make sure the prediction horizon was provided
			error(obj.assert_controllerparams_defined);

			if isempty(obj.nu)
				error('Set ctrl.nu first.');
			end
			
            % evaluate the explicit optimizer
			xinit = xinit(:);
			if numel(xinit) ~= obj.nx
				error('The point must be a %dx1 vector.', obj.nx);
			end

			% index of the optimizer and index of the region from which the
			% control action was extracted
			opt_region = [];
			opt_partition = [];
			
			% evaluate the primal optimizer, break ties based on the cost
			% function. guarantees that the output is a single region where
			% the cost is minimal.
			if numel(obj.optimizer)==1
				% simple case, just a single optimizer
				[U, feasible, idx, J] = obj.optimizer.feval(xinit, ...
					'primal', 'tiebreak', 'obj');
				if ~feasible
					J = Inf;
					% U is already a vector of NaNs by Union/feval
					
				elseif isempty(J)
					% no tie-breaking was performed, compute cost manually

					% Note: from a long-term sustainibility point of view
					% we should use
					%   J = obj.optimizer.Set(idx).feval(xinit, 'obj');
					% here. but ConvexSet/feval() adds so much unnecessary
					% overhead that we better evaluate the function
					% directly
					J = obj.optimizer.Set(idx).Functions('obj').Handle(xinit);
				end
				if feasible
					opt_partition = 1;
					opt_region = idx;
				end
				
			else
				% multiple optimizers, pick the partition in which the cost
				% is minimal

				[U, feas, idx, J] = obj.optimizer.forEach(@(opt) opt.feval(xinit, ...
					'primal', 'tiebreak', 'obj'), 'UniformOutput', false);
				% only consider partitions that contain "xinit"
				feasible_idx = find(cellfun(@(x) x, feas));
				if isempty(feasible_idx)
					feasible = false;
					U = U{1}; % it's set to NaN by Union/feval
					J = Inf;
					
				else
					% compute cost in the best region of each feasible
					% partition
					feasible = true;
					for i = feasible_idx
						if isempty(J{i})
							% no cost provided by tie-breaking, compute it
							% manually
							J{i} = obj.optimizer(i).Set(idx{i}).Functions('obj').Handle(xinit);
						end
					end
					Jmin = cat(2, J{feasible_idx});
					[J, best_partition] = min(Jmin);
					U = U{feasible_idx(best_partition)};
					opt_region = idx{feasible_idx(best_partition)};
					opt_partition = feasible_idx(best_partition);
				end
			end
			
			if numel(U)~=obj.nu*obj.N
				% sanity checks for EMPCControllers imported from
				% polyunions
				error('Number of optimizers is inconsistent with "N" and/or "nu".');
			end
			
			u = U(1:obj.nu);
			if nargout==3
				openloop.cost = J;
				openloop.U = reshape(U, [obj.nu obj.N]);
				openloop.X = NaN(obj.nx, obj.N+1);
				openloop.Y = NaN(obj.model.ny, obj.N);
				openloop.partition = opt_partition;
				openloop.region = opt_region;
			end
		end
		
		function out = simplify(obj)
			% Simplifies the explicit controller by merging together
			% regions which share the same feedback law
			
			if nargout==0
				% in-place merging
				out = obj;
			else
				% copy-and-merge
				out = obj.copy;
			end
			out.optimizer.trimFunction('primal', obj.nu);
			out.optimizer.merge('primal');
			out.N = 1; % to get correct size of the open-loop optimizer
			% TODO: implement a better way
		end
		
		function data = clicksim(obj, varargin)
			% Select initia condition for closed-loop simulation by mouse
			%
			%   controller.clicksim(['option', value, ...)
			%
			% Select initial points by left-click. Abort by right-click.
			%
			% options:
			%  'N_sim': length of the closed-loop simulation (default: 100)
			%  'x0': initial point, if provided, the method exits
			%        immediately (default: [])
			%  'alpha': transparency of the partition (default: 1)
			%  'color': color of the closed-loop profiles (default: 'k')
			%  'linewidth': width of the line (default: 2)
			%  'marker': markers indicating points (default: '.')
			%  'markersize': size of the markers (default: 20)
			
			if obj.nx~=2
				error('Only 2D partitions can be plotted.');
			end
			ip = inputParser;
			ip.addParamValue('x0', []);
			ip.addParamValue('N_sim', 50, @isnumeric);
			ip.addParamValue('alpha', 1, @isnumeric);
			ip.addParamValue('linewidth', 2, @isnumeric);
			ip.addParamValue('color', 'k');
			ip.addParamValue('marker', '.');
			ip.addParamValue('markersize', 20);
			ip.parse(varargin{:});
			options = ip.Results;
			
			obj.optimizer.plot('alpha', options.alpha);
			hold on
			button = 1;
			while button~=3
				if isempty(options.x0)
					[x, y, button] = ginput(1);
					x0 = [x; y];
				else
					x0 = options.x0;
					button = 3;
				end
				data = obj.simulate(x0, options.N_sim);
				plot(data.X(1, :), data.X(2, :), options.color, ...
					'linewidth', options.linewidth, ...
					'marker', options.marker, ...
					'markersize', options.markersize);
				title(sprintf('Closed-loop simulation: x0 = %s', mat2str(x0)));
			end
			hold off
			if nargout==0
				clear data
			end
			
		end
	end
	
	methods(Static, Hidden)
		% private APIs, use at your own risk
		
		function optimizer = addMissingFunctions(optimizer, varargin)
			% Adds missing functions to the optimizer
			
			% TODO: check dimensions
			
			% Any PolyUnion representing an explicit solution has to
			% contain following functions: 'z', 'w', 'primal', 'dual',
			% 'obj'. Any missing function is replaced by a zero function.
			%
			% Moreover, we can add other functions, specified in the
			% function call, e.g.:
			%    opt = obj.addMissingFunctions(obj, opt, 'myFun',
			%    AffFunction)
			% which adds the function 'myfun' to all polyhedra of the
			% PolyUnion 'opt'.

			required_names = {'z', 'w', 'primal', 'dual', 'obj'};
			required_args = cell(1, length(required_names));
			for i = 1:2:length(varargin)/2
				required_names{end+1} = varargin{i};
				required_args{end+1} = varargin{i+1};
			end
			
			% TODO: keep the list of functions in sync with the Opt class
			for i = 1:length(optimizer)
				funs = optimizer(i).listFunctions;
				missing = find(ismember(required_names, funs)==0);
				if ~isempty(missing)
					for k = 1:length(missing)
						for j = 1:length(optimizer(i).Set)
							if isempty(required_args{missing(k)})
								addf = AffFunction(zeros(1, optimizer(i).Set(j).Dim));
							else
								addf = required_args{missing(k)};
							end
							optimizer(i).Set(j).addFunction(addf, ...
								required_names{missing(k)});
						end
					end

					% update list of functions associated to the union
					optimizer(i).setInternal('FuncName', required_names);
				end
			end
		end
		
		function [nx, nu] = checkOptimizer(optimizer)
			% checks sanity of an explicit optimizer
			
			if isa(optimizer, 'double') && isempty(optimizer)
				% setting the optimizer to [] should work
				return
			end
			if ~isa(optimizer, 'PolyUnion')
				error('Optimizer must be an instance of the @PolyUnion class.');
			end
			
			nx = zeros(1, numel(optimizer));
			nu = zeros(1, numel(optimizer));
			% check that we have at least the 'primal' and 'obj'
			% functions and determine number of paramters (nx) and number
			% of optimizer's outputs (nu)
			for i = 1:numel(optimizer)
				if optimizer(i).Num<1
					error('Optimizer %d must contain at least one region.', i);
				elseif ~any(cellfun(@(x) isequal(x, 'primal'), optimizer(i).listFunctions))
					error('Optimizer %d must contain the "primal" function.', i);
				elseif ~any(cellfun(@(x) isequal(x, 'obj'), optimizer(i).listFunctions))
					error('Optimizer %d must contain the "obj" function.', i);
				end
				nx(i) = optimizer(i).Dim;
				primal = optimizer(i).Set(1).getFunction('primal');
				nu(i) = length(primal.g);
			end
			% check that all polyunions are of the same dimension
			if any(diff(nx)~=0)
				error('All optimizers must have equal dimensions.');
			end
			if any(diff(nu)~=0)
				error('All optimizers must have the same number of optimization variables.');
			end
			nx = nx(end);
			nu = nu(end);
		end

	end
	
	methods(Access=protected)
		
		function obj = importUserData(obj, varargin)
			% Imports model / prediction horizon

			obj = obj.importUserData@AbstractController(varargin{:});

			if nargin==2 
				% possible import from an another controller
				otherCtrl = varargin{1};
				if isa(otherCtrl, 'AbstractController') && ...
						otherCtrl.isExplicit() && isobject(otherCtrl.optimizer)
					% import optimizer
					obj.model = otherCtrl.model;
					obj.N = otherCtrl.N;
					obj.optimizer = otherCtrl.optimizer;
					%obj.optimizer=obj.addMissingFunctions(otherCtrl.optimizer);
					return
					
				elseif isa(otherCtrl, 'PolyUnion')
					% import optimizer, use dummy system
					obj.model = LTISystem;
					optimizer = otherCtrl;
					obj.nx = obj.checkOptimizer(optimizer);
					obj.optimizer = optimizer.copy;
					%obj.optimizer=obj.addMissingFunctions(otherCtrl);
					return
				end
			end

		end

	end
end
