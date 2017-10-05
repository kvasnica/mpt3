function test_polyunion_le_05_pass
% Polyhedron <= PolyUnion, PolyUnion <= Polyhedron

P1 = Polyhedron.unitBox(2);
P3 = P1+[1; 0];
P4 = P1 + [0.3; 0];
Q = Polyhedron.unitBox(2)*10;
assert(P4<=PolyUnion([P1 P3]));
assert(PolyUnion([P1 P3])<=Q);
assert(~(PolyUnion([P1 P3])<=P1));

end
