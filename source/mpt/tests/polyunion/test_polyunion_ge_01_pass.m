function test_polyunion_ge_01_pass
% Polyhedron >= PolyUnion, PolyUnion >= Polyhedron

P1 = Polyhedron.unitBox(2);
P3 = P1+[1; 0];
P4 = P1 + [0.3; 0];
Q = Polyhedron.unitBox(2)*10;
assert(PolyUnion([P1 P3])>=P4);
assert(Q>=PolyUnion([P1 P3]));
assert(~(P1>=PolyUnion([P1 P3])));

end
