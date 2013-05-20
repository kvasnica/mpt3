function test_polyunion_plus_10_pass
%
% minkowski addtion of two polyunions

A = Polyhedron(randn(10, 2)).minHRep();
B = Polyhedron(randn(10, 2)).minHRep();
C = Polyhedron(randn(10, 2)).minHRep();
D = Polyhedron(randn(10, 2)).minHRep();

S = PolyUnion([A B])+PolyUnion([C D]);
assert(S.Num==4);
