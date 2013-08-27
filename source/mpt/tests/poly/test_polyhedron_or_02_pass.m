function test_polyhedron_or_02_pass
% tests the "|" operator

% union is not convex
P1 = Polyhedron('lb', 1, 'ub', 1.5);
P2 = Polyhedron('lb', 2, 'ub', 2.5);
[R, isConvex] = P1|P2;

% since the union is not convex, [P1 P2] must be returned
assert(isa(R, 'Polyhedron'));
assert(numel(R)==2);
assert(R(1)==P1.copy());
assert(R(2)==P2.copy());
assert(~isConvex);

end
