classdef SeparationController < EMPCController
    % Class representing explicit separation-based controllers
    %
    % Constructor:
	%   ctrl = SeparationController(explicit_controller)
	%
	% Literature: Kvasnica, M. - Hledik, J. - Rauova, I. - Fikar, M.:
	% Complexity reduction of explicit model predictive control via
	% separation. Automatica, no. 6, vol. 49, pp. 1776-1781, 2013.  
	
	properties
		LowerSaturation
		UpperSaturation
		Domain
	end
	
    methods
		
		function out = getName(obj)
			out = 'Explicit separation-based controller';
		end

        function obj = SeparationController(ctrl)
            % Constructor:
			%   ctrl = SeparationController(explicit_controller)
            
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
			% Constructs the separation-based controller
			
			obj.LowerSaturation = obj.model.u.min;
			obj.UpperSaturation = obj.model.u.max;
			obj.Domain = obj.optimizer.convexHull();
			
			% determine saturation properties
			sat = obj.optimizer.findSaturated('primal');
			
			separator = obj.separate(obj.optimizer.Set(sat.Imin), ...
				obj.optimizer.Set(sat.Imax), obj.optimizer.Dim);
			
			% NOTE: ideally we would like to use the separator returned
			% directly by separate(). However, at least in Matlab R2011,
			% evaluation of such handles is horrendously slow. That's why
			% we re-create them here
			separator = eval(func2str(separator));
			obj.Domain.addFunction(separator, 'separator');
			
			% only keep the unsaturated regions
			obj.optimizer = PolyUnion(obj.optimizer.Set(sat.Iunsat));
		end
		
		function [u, feasible, openloop] = evaluate(obj, xinit, varargin)
			% Evaluates the separation controller for a given point
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
			
			if ~feasible
				% point "xinit" is not in the unsaturated regions, but it
				% can still be in one of the saturated regions. Check the
				% separator
				[sep_val, feasible] = obj.Domain.feval(xinit, 'separator');
				if feasible && sep_val > 0
					% point belongs to a region saturated at maximum
					u = obj.UpperSaturation;
				elseif feasible && sep_val < 0
					% point belongs to a region saturated at minimum
					u = obj.LowerSaturation;
				end
				if feasible
					openloop.cost = 0;
					openloop.U = u;
				end
			end
		end
	end
	
	methods (Static, Hidden)
		
        function separator = separate(Pmin, Pmax, nx)
            % Linear separation of two sets of polyhedra
			
			global MPTOPTIONS
			% TODO: check that the feedback law is continuous

			if isempty(Pmin)
				% all other regions are saturated at maximum
				separator = @(x) zeros(1, nx)*x+1;
				return
			elseif isempty(Pmax)
				% all other regions are saturated at minimum
				separator = @(x) zeros(1, nx)*x-1;
				return
			end
			
			% quick-and-dirty approach via vertices
			a = sdpvar(1, nx);
			b = sdpvar(1, 1);
			sep_fun = @(x) a*x+b;
			CON = [];
			fprintf('Formulating constraints...\n');
			tic
			for i = 1:numel(Pmin)
				% display progress
				if toc > MPTOPTIONS.report_period
					fprintf('%d / %d\n', i, length(Pmin)+length(Pmax));
					tic
				end
				V = Pmin(i).V;
				CON = CON + [ sep_fun(V') <= -1 ];
			end
			for i = 1:numel(Pmax)
				% display progress
				if toc > MPTOPTIONS.report_period
					fprintf('%d / %d\n', i+length(Pmax), length(Pmin)+length(Pmax));
					tic
				end
				V = Pmax(i).V;
				CON = CON + [ sep_fun(V') >= 1 ];
			end
			fprintf('Solving the separation problem...\n');
			info = solvesdp(CON, []);
			if info.problem~=0
				warning(info.info);
			end
			
			% optimal separator
			aopt = double(a);
			bopt = double(b);
			% use eval() since we need to insert specific numbers instead
			% of references to symbolic names "aopt" and "bopt"
			separator = eval(sprintf('@(x) %s*x+%s', mat2str(aopt), mat2str(bopt)));
		end

    end
end
