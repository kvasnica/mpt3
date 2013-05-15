classdef Penalty < matlab.mixin.Copyable & IterableBehavior
	%Object representation of a penalty function
	%
	% Constructor:
	%    p = Penalty(Q, 0)    0-norm penalty Q*z
	%    p = Penalty(Q, 1)    1-norm penalty ||Q*z||_1
	%    p = Penalty(Q, Inf)  Inf-norm penalty ||Q*z||_Inf
	%    p = Penalty(Q, 2)    quadratic penalty z'*Q*z
    
    properties(SetAccess = public)
        Q
		norm
	end
	properties(SetAccess = private, Hidden)
		f
	end
    	
    methods
        
        function obj = Penalty(Q, type)
            % Constructor:
            %    p = Penalty(Q, 0)    0-norm penalty Q*z
            %    p = Penalty(Q, 1)    1-norm penalty ||Q*z||_1
            %    p = Penalty(Q, Inf)  Inf-norm penalty ||Q*z||_Inf
            %    p = Penalty(Q, 2)    quadratic penalty z'*Q*z

            if nargin == 0
                return
            end
            if nargin==1 && isa(Q, 'Penalty')
				% copy constructor
				obj = Q.copy();
                return
            elseif nargin~=2
                error('Not enough input arguments.');
			end

			obj.norm = type;
            obj.Q = Q;
			obj.f = obj.buildNormFunction(obj.Q, obj.norm);
		end
        
		function obj = set.Q(obj, Q)
			% Updates the penalization matrix
			
			obj.Q = Q;
			obj.f = obj.buildNormFunction(obj.Q, obj.norm);
		end

		function obj = set.norm(obj, type)
			% Updates the penalty type (0/1/2/Inf)
			
			obj.norm = type;
			obj.f = obj.buildNormFunction(obj.Q, obj.norm);
		end

        function v = evaluate(obj, z)
            % Evaluates the penalty for a given value of variable "z"
            
            v = obj.f(z);
        end
        
	end

	methods(Static, Hidden)
		
		function fun = buildNormFunction(Q, type)
			% Converts the penalty to a function handle
			
			if isempty(type)
				fun = [];
			elseif isa(type, 'double')
				switch type,
					case 0,
						fun = @(x) Q*x;
					case 2,
						fun = @(x) x'*Q*x;
					otherwise,
						fun = eval(sprintf('@(x) norm(Q*x, %s)', num2str(type)));
				end
			else
				error('Unrecognized function type.');
			end
		end
	end

end
            
