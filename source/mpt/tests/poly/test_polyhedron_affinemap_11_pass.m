function test_polyhedron_affinemap_11_pass
% mapping with a zero matrix should work and produce a zero singleton of
% appropriate dimension

P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);

% scalar scaling, should produce a lower-dimensional 2D set with zero vertex
M = 0;
R = M*P;
assert(R.Dim==P.Dim);
assert(~R.isEmptySet()); % the set 0*P is NOT an empty set!
assert(~R.isFullDim()); % and not fully dimensional
assert(isequal(R.V, zeros(1, R.Dim))); % because it's a singleton

% projection, should produce a lower-dimensional 1D set with zero vertex
M = [0 0];
R = M*P;
assert(R.Dim==size(M, 1));
assert(R.hasHRep); % both representations must be returned
assert(R.hasVRep);
assert(~R.isEmptySet()); % the set 0*P is NOT an empty set!
assert(~R.isFullDim()); % and not fully dimensional
assert(isequal(R.V, zeros(1, size(M, 1)))); % because it's a singleton

% affine map, should produce a lower-dimensional 2D set with zero vertices
M = zeros(2);
R = M*P;
assert(R.Dim==size(M, 1));
assert(~R.isEmptySet());
assert(~R.isFullDim());
assert(isequal(R.V, zeros(1, size(M, 1))));

% lifting, should produce a lower-dimensional 4D set with zero vertices
M = zeros(4, 2);
R = M*P;
assert(R.Dim==size(M, 1));
assert(~R.isEmptySet());
assert(~R.isFullDim());
assert(isequal(R.V, zeros(1, size(M, 1))));

% numerical noise should not corrupt the computation
M = [1e-9, 0];
R = M*P;
assert(R.Dim==size(M, 1));
assert(~R.isEmptySet());
assert(~R.isFullDim());
assert(isequal(R.V, zeros(1, size(M, 1))));

end
