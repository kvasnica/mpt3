classdef ClippingController < EMPCController
    % Class representing explicit clipping-based controllers
    %
    % Constructor:
	%   ctrl = ClippingController(explicit_controller)
	%
	% Literature: Kvasnica, M. and Fikar, M.: Clipping-Based Complexity
	% Reduction in Explicit MPC. IEEE Transactions on Automatic Control,
	% no. 7, vol. 57, pp. 1878-1883, 2012.
	
	properties
		LowerSaturation
		UpperSaturation
	end
	
    methods
		
		function out = getName(obj)
			out = 'Explicit clipping-based controller';
		end

        function obj = ClippingController(ctrl)
            % Constructor:
			%   clip = ClippingController(explicit_controller)
            
			if nargin==0
                return
			elseif ~isa(ctrl, 'EMPCController')
				error('Input must be an EMPCController object.');
			end
			% copy data from the source object
			obj.importUserData(ctrl.copy());
			
			% only keep u0
			obj.optimizer.trimFunction('primal', obj.nu);
			obj.N = 1; % to get correct size of the open-loop optimizer
			% TODO: implement a better way

			% clip each optimizer
			obj.LowerSaturation = obj.model.u.min;
			obj.UpperSaturation = obj.model.u.max;
			newopt = [];
			for i = 1:numel(obj.optimizer)
				clipped = obj.clip(obj.optimizer(i), ...
					obj.LowerSaturation, obj.UpperSaturation);
				newopt = [newopt, clipped];
			end
			obj.optimizer = newopt;
		end
		
		function [u, feasible, openloop] = evaluate(obj, xinit, varargin)
			% Evaluates the clipping controller for a given point
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
			%
			% u = controller.evaluate(x0, 'x.reference', ref, 'u.prev', u0)
			% includes "ref" and "u0" into the vector of initial
			% conditions.

			% evaluate the unclipped PWA feedback
			[u, feasible, openloop] = obj.evaluate@EMPCController(xinit, varargin{:});
			
			if feasible
				% clip the optimal control action
				u = max(min(u, obj.UpperSaturation), obj.LowerSaturation);
				% clear the open-loop control profile
				openloop.U = NaN(size(openloop.U));
			end
		end
	end
	
	methods (Static, Hidden)
		
        function new = clip(optimizer, min_value, max_value)
            % clips a single optimizer
			
			global MPTOPTIONS
			
			% TODO: check that the feedback law is continuous

			% determine saturation properties
			sat = optimizer.findSaturated('primal');

			% compute adjacency list
			% TODO: implement via issue #4
			if ~isfield(optimizer.Internal, 'adj_list')
				error('The adjacency list is missing.');
			end
			adj = optimizer.Internal.adj_list;

			Porig = optimizer.Set;
			Hull = optimizer.convexHull();
			Pnew = [];
			
			tic
			for ii = 1:length(sat.Iunsat)
				i = sat.Iunsat(ii);
				% display progress
				if toc > MPTOPTIONS.report_period
					fprintf('%d / %d\n', ii, length(sat.Iunsat));
					tic
				end
				
				% find facets over which we have a unsaturated neighbor
				unsat_neighbor_facet = [];
				for k = 1:length(adj{i})
					if any(ismember(adj{i}{k}, sat.Iunsat))
						unsat_neighbor_facet = [unsat_neighbor_facet, k];
					end
				end
				
				if ~isempty(unsat_neighbor_facet)
					% extend this unsaturated region over facets over which
					% we have a saturated neighbor
					A = [Porig(i).A(unsat_neighbor_facet, :); Hull.A];
					b = [Porig(i).b(unsat_neighbor_facet, :); Hull.b];
					P = Polyhedron(A, b);

					% remove parts of other unsaturated regions
					P = P \ Porig(setdiff(sat.Iunsat, i));
					if numel(P)>1
						% simplify
						P = PolyUnion(P).merge().Set;
					end
				end
				
				% assign functions
				feedback = Porig(i).Functions('primal');
				P.addFunction(feedback, 'primal');
				% reset cost
				cost = Porig(i).Functions('obj');
				if isa(cost, 'QuadFunction')
					cost = QuadFunction(0*cost.H, 0*cost.F, 0*cost.g);
				elseif isa(cost, 'AffFunction')
					cost = QuadFunction(0*cost.F, 0*cost.g);
				else
					error('Unsupported objective function of type "%s".', ...
						class(cost));
				end
				P.addFunction(cost, 'obj');
				Pnew = [Pnew P];
			end
			% create new optimizer
			new = PolyUnion(Pnew);
			% TODO: copy all Internal properties
		end

    end
end
