function test_voronoi_04_pass
% some cells are empty due to bounding

% check basic properties
S = [5, 1, 2];
B = Polyhedron('lb', 1.8);
[V, P] = mpt_voronoi(S, 'bound', B);
G5 = Polyhedron('lb', 3.5);
G2 = Polyhedron('lb', 1.8, 'ub', 3.5);

assert(isa(V, 'PolyUnion'));
assert(numel(P)==size(S, 2)); % must also include empty cells
assert(V.Num==2); % only non-empty cells
assert(V.Dim==size(S, 1));
assert(V.Internal.Convex);
assert(~V.Internal.Overlaps);
assert(V.Internal.Connected);

% P(2) must be empty
assert(P(2).isEmptySet);
assert(V.Set(1)==G5);
assert(V.Set(2)==G2);
assert(~V.Set(1).isBounded);
assert(V.Set(2).isBounded);

end
