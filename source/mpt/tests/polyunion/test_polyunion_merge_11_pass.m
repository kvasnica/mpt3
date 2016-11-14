function test_polyunion_merge_11_pass
% PolyUnion/merge() must correctly update the Domain

% domain is a single polyhedron
P1 = Polyhedron('lb', -1, 'ub', 0);
P2 = Polyhedron('lb', 0, 'ub', 1);
P3 = Polyhedron('lb', 1, 'ub', 2);
D = Polyhedron('lb', -1, 'ub', 2);
U = PolyUnion('Set', [P1 P2 P3], 'Domain', D);
Um = U.merge();
assert(Um.Num==1);
assert(Um.Set==D);
assert(length(Um.Domain)==1);
assert(Um.Domain==D);

% domain are multiple polyhedra
P1 = Polyhedron('lb', -1, 'ub', 0);
P2 = Polyhedron('lb', 0, 'ub', 1);
P3 = Polyhedron('lb', 1, 'ub', 2);
D1 = Polyhedron('lb', -1, 'ub', 1.2);
D2 = Polyhedron('lb', 1.2, 'ub', 2);
U = PolyUnion('Set', [P1 P2 P3], 'Domain', [D1 D2]);
Um = U.merge();
assert(Um.Num==1);
assert(Um.Set==D);
% merged set is simpler than the domain => Domain=Set
assert(length(Um.Domain)==1);
assert(Um.Domain==D);

% and once more, but this time with in-place merging
U = PolyUnion('Set', [P1 P2 P3], 'Domain', [D1 D2]);
U.merge();
assert(U.Num==1);
assert(U.Set==D);
assert(length(U.Domain)==1);
assert(U.Domain==D);

end
