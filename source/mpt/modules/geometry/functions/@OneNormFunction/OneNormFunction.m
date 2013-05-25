classdef OneNormFunction < NormFunction
	%
	% represents weighted 1-norm functions
	%
	% syntax:
	%   f = OneNormFunction(Q) : f = norm(Q*x, 1)
	%
	% "Q" need not to be square. Function value is always scalar.
	
	methods
		
		% Constructor
		function obj = OneNormFunction(Q)
			% Constructs a weighted 1-norm function object
			%
			% syntax:
			%   f = OneNormFunction(Q) : f = norm(Q*x, 1)
			%
			% "Q" need not to be square. Function value is always scalar.
			
			obj = obj@NormFunction(1, Q);
		end
		
	end
	
end
