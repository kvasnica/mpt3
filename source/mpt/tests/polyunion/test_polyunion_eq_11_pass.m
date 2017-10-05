function test_polyunion_eq_11_pass
% Polyhedron == PolyUnion, PolyUnion == Polyhedron

P1 = Polyhedron.unitBox(2)+[-1; 0];
P2 = Polyhedron.unitBox(2)+[1; 0];
Q = Polyhedron('lb', [-2; -1], 'ub', [2; 1]);
assert(Q==PolyUnion([P1 P2]));
assert(PolyUnion([P1 P2])==Q);
assert(~(P1==PolyUnion([P1 P2])));
assert(~(PolyUnion([P1 P2])==P2));

end
