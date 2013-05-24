function S = slice(P, dims, values)
%
% Slice a polyhedron by through given dimensions
%
% S = P.slice(dims)
% S = P.slice(dims, values)
%
% If "values" is omitted, then "values = zeros(size(dims))".
%
% When P = {x | A*x <= b, Aeq*x == beq}, then
% S = { x | A*x <= b, Aeq*x == beq, x(dims) == values }
%
% Note that dimension of S is equal to dimension of P.

error(nargchk(2, 3, nargin));
if nargin<3
	values = zeros(size(dims));
end

%% deal with arrays
if numel(P)>1
	S = P.forEach(@(e) e.slice(dims, values));
	return
end
        
%% validation
if P.isEmptySet
    error('Cannot slice empty polyhedra.');
end
% check dimensions
for i=1:numel(dims)
    validate_dimension(dims(i));
end
if any(dims>P.Dim)
    error('The second input cannot exceed dimension of the polyhedron.');
end
if numel(values)~=numel(dims)
	error('"values" must be a vector with %d element(s).', numel(dims));
end

%% computation

% require the H-representation (the getters computes it automatically if
% it does not exist)
Z = zeros(numel(dims), P.Dim);
for i = 1:numel(dims)
	Z(i, dims(i)) = 1;
end
S = Polyhedron('H', P.H, 'He', [P.He; [Z, values(:)]]);

end
