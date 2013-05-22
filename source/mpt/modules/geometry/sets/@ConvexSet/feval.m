function [fval, feasible] = feval(obj, x, function_name)
% 
% Synopsis:
% ---
% 
% Evaluates a function defined over a convex set or an array thereof
% 
% Syntax:
% ---
% 
% [fval, feasible] = S.feval(x)
% [fval, feasible] = S.feval(x, function_name)
% 
% Inputs:
% ---
% 
%   S: convex set or an array thereof (mandatory)
%   x: point at which the function should be evaluated (mandatory)
%   function_name: string name of the function to evaluate. it must refer
%                  to a single function. if omitted, "S.feval(x)" only
%                  works if the set has a single function. 
% 
% Outputs:
% ---
% 
%   fval: (n x m) matrix of function values at "x", where "m" is the number
%         of sets. if "x" is not contained in the j-th set, then the j-th
%         column of "fval" is a vector of NaNs.
%   feasible: (1 x m) vector of logicals. "feasible(j)=true" if the j-th
%             element of the array contains "x"
% 
% TODO: support evaluation of multiple points ("x" is a matrix with points
%       stored column-wise), make Union/feval to behave similarly

%% basic error checks
error(nargchk(2, 3, nargin));
if nargin==2
	function_name = '';
end
n_obj = numel(obj);
if n_obj==0
	% exit quickly if we have an empty set (in the matlab sense of empty)
	fval = [];
	feasible = false;
	return
end

%% validate arguments
if isempty(function_name)
	fnames = obj(1).listFunctions();
	if isempty(fnames)
		error('The object has no functions.');
	elseif numel(fnames)>1
		error('The object has multiple functions, specify the one to evaluate.');
	else
		function_name = fnames{1};
	end
	% check that all remaining sets have this function defined
	for i = 2:numel(obj)
		if ~obj(i).hasFunction(function_name)
			error('No such function "%s" in set %d.', function_name, i);
		end
	end
elseif ~ischar(function_name)
	error('The function name must be a string.');
elseif any(~obj.hasFunction(function_name))
	error('No such function "%s" in the object.', function_name);
end

%% evaluate
validate_realvector(x);
if n_obj==1
	% faster implementation for single sets
	feasible = obj.contains(x);
	fval = obj.Functions(function_name).Handle(x);
	if ~feasible
		fval = NaN(size(fval));
	end
else
	% arrays of sets
	feasible = false(1, n_obj);
	fval = [];
	for i = 1:n_obj
		feasible(i) = obj(i).contains(x);
		f = obj(i).Functions(function_name).Handle(x);
		if ~feasible(i)
			f = NaN(size(f));
		end
		fval = [fval f];
	end
end

end
