function test_polyunion_merge_12_pass
% merge() on arrays

P1 = Polyhedron.unitBox(2)+[-1; 0];
P2 = Polyhedron.unitBox(2)+[1; 0];
Q1 = Polyhedron.unitBox(2)+[2; 0];
Q2 = Polyhedron.unitBox(2)+[1; 0];
U1 = PolyUnion([P1 P2]);
U2 = PolyUnion([Q1 Q2]);
U = [U1 U2];

% original objects must stay the same
q = merge(U);
assert(numel(q)==2);
assert(q(1).Num==1);
assert(q(2).Num==2);
assert(U(1).Num==2);
assert(U(2).Num==2);

% in-place merging must modify the original objects
U = [U1 U2];
U.merge()
assert(U(1).Num==1);
assert(U(2).Num==2);

end
