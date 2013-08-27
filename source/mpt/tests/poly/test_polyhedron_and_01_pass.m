function test_polyhedron_and_01_pass
% tests the "&" operator

P1 = Polyhedron('lb', 1, 'ub', 1.5);
P2 = Polyhedron('lb', 1.3, 'ub', 2);
expected = Polyhedron('lb', 1.3, 'ub', 1.5);

R = P1&P2;
assert(R==expected);

end
