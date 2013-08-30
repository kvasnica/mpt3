function test_polyhedron_minus_18_pass
% 1D polyhedra must work

P = Polyhedron('lb', -1, 'ub', 1);
Q = Polyhedron('lb', -0.1, 'ub', 0.1);
M = P-Q;
expected = Polyhedron('lb', -0.9, 'ub', 0.9);
assert(M==expected);

end
