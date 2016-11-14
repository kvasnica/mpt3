function test_polyunion_merge_09_pass

p1 = Polyhedron('lb', -1, 'ub', 0);
p2 = Polyhedron('lb', 0, 'ub', 1);

% test in-place merging;
U = PolyUnion([p1 p2]);
U.merge;
assert(U.Num==1);
assert(U.Set==Polyhedron('lb', -1, 'ub', 1));

% merging with extra output
U = PolyUnion([p1 p2]);
M = U.merge;
assert(U.Num==2); % input union should be unchanged
assert(M.Num==1);
assert(M.Set==Polyhedron('lb', -1, 'ub', 1));
