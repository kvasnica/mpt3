function test_empccontroller_toInvariant_01_pass
% tests MPCController/toInvariant

model = LTISystem('A', 2, 'B', 1, 'C', 1, 'D', 0);
model.x.min = -5;
model.x.max = 5;
model.u.min = -1;
model.u.max = 1;
model.x.penalty = Penalty(1, 1);
model.u.penalty = Penalty(1, 1);

M = MPCController(model, 3).toExplicit;
Mold = M.copy();
Sold = Mold.partition.convexHull;
assert(Sold==Polyhedron('lb', -1.5, 'ub', 1.5));
M.toInvariant();
S = M.partition.convexHull;
assert(S>=Polyhedron('lb', -1, 'ub', 1));
assert(S<=Polyhedron('lb', -1.001, 'ub', 1.001));

end
