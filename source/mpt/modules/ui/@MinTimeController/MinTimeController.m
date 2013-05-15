classdef MinTimeController < MPCController
    % Class representing minimum-time controllers
    %
    % Constructor:
	%   ctrl = MinTimeCController(model)
	
    methods
		
		function out = getName(obj)
			out = 'Minimum-time controller';
		end

        function obj = MinTimeController(varargin)
            % Constructor:
			%
			% Constructor:
			%   ctrl = MinTimeCController(model)
            
			if nargin==0
				return
			end

			obj.importUserData(varargin{:});
			obj.N = 1;
		
		end

		function out = toExplicit(obj)
			% Computes the explicit controller
			
			out = EMinTimeController(obj);
		end
		
		function [u, feasible, openloop] = evaluate(obj, xinit)
			error('Call obj.toExplicit() to obtain an explicit version of the controller.');
		end

		function obj = construct(obj)
			% We do not provide implementation of on-line minimum-time
			% control yet
		end
		
		function Y = toYALMIP(obj)
			error('Minimum-time setups cannot be exported to YALMIP.');
		end
		
		function obj = fromYALMIP(obj, Y)
			error('Minimum-time setups cannot be imported to YALMIP.');
		end
		
    end
end
