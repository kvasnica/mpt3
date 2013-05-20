function test_polyhedron_contains_28_pass
%
% P is an array, "x" a single polyhedron

P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', 0, 'ub', 2);
P = [P1 P2];

% x contained in P1
x = Polyhedron('lb', -0.5, 'ub', 0);
t = P.contains(x);
assert(isequal(t, [true; false]));

% x contained in P2
x = Polyhedron('lb', 0.5, 'ub', 1.5);
t = P.contains(x);
assert(isequal(t, [false; true]));

% x in both
x = Polyhedron('lb', 0.5, 'ub', 0.8);
t = P.contains(x);
assert(isequal(t, [true; true]));

end
