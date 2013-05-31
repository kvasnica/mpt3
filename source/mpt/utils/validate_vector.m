function msg = validate_vector(x, nx, label, nc)
% Validates that "x" is an (nx x 1) vector
%
% Returns a non-empty string if "x0" does not match dimension
% of the state vector. returns an empty vector if everything is
% ok.

if nargin<3
	label = 'point';
end
if nargin<4
	nc = 1;
end
if ~isequal(size(x), [nx nc])
	msg = sprintf('The %s must be a %dx%d vector.', label, nx, nc);
else
	msg = '';
end

end
