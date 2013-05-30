function test_voronoi_02_pass
% 1D points

% check basic properties
S = [5, 1, 2];
V = mpt_voronoi(S);
assert(isa(V, 'PolyUnion'));
assert(V.Num==size(S, 2));
assert(V.Dim==size(S, 1));
assert(V.Internal.Convex);
assert(~V.Internal.Overlaps);
assert(V.Internal.Connected);

%% no bounds
% check correctness of the output, regions must be generated in a correct
% order!
G5 = Polyhedron('lb', 3.5);
G1 = Polyhedron('ub', 1.5);
G2 = Polyhedron('lb', 1.5, 'ub', 3.5);
assert(V.Set(1)==G5);
assert(V.Set(2)==G1);
assert(V.Set(3)==G2);

% Set(1) and Set(2) must be unbounded
assert(~V.Set(1).isBounded);
assert(~V.Set(2).isBounded);
assert(V.Set(3).isBounded);

%% with bounds
V = mpt_voronoi(S, 'bound', Polyhedron('lb', -1, 'ub', 6));
G5 = Polyhedron('lb', 3.5, 'ub', 6);
G1 = Polyhedron('ub', 1.5, 'lb', -1);
G2 = Polyhedron('lb', 1.5, 'ub', 3.5);
assert(V.Set(1)==G5);
assert(V.Set(2)==G1);
assert(V.Set(3)==G2);
assert(all(V.Set.isBounded));

end
