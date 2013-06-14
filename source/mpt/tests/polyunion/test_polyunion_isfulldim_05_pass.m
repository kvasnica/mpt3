function test_polyunion_isfulldim_05_pass
% wrong output in 1D (due to a bug in Polyhedron/isEmptySet)

P = Polyhedron('lb', -1, 'ub', 1);
V = 0;
Q = Polyhedron(V);
assert(P.isFullDim);
assert(~Q.isFullDim);
assert(~Q.isEmptySet); % bug in Polyhedron/isEmptySet with V=0

U = PolyUnion([P Q]);
assert(U.Num==2);
assert(~U.isFullDim);

end
