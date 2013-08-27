function test_polyhedron_or_01_pass
% tests the "|" operator

% union is convex
P1 = Polyhedron('lb', 1, 'ub', 1.5);
P2 = Polyhedron('lb', 1.3, 'ub', 2);
expected = Polyhedron('lb', 1, 'ub', 2);
[R, isConvex] = P1|P2;

% since the union is convex, a single polyhedron must be returned
assert(isa(R, 'Polyhedron'));
assert(numel(R)==1);
assert(R==expected);
assert(isConvex);

end
