function assertwarning(expression)
% same as assert(), but raises a warning instead of an error

w = warning;
warning on
if ~expression
	warning('??? Assertion failed.');
end
warning(w);
