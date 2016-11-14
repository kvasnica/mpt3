function test_polyhedron_intersect_10_pass
% if intersection is an empty set, it must be of correct dimension

P1 = Polyhedron('lb', [0; 0], 'ub', [1; 1]);
P2 = Polyhedron('lb', [2; 2], 'ub', [3; 3]);
I = P1.intersect(P2);
assert(I.isEmptySet());
assert(I.Dim==2);

end
