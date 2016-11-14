function test_polyhedron_isbounded_16_pass
% boundedness check for lower-dimensional polyhedra (issue #112)

% same as test_polyhedron_isbounded_15_pass, but here the equalities are
% embedded as double-sided inequalities

% bounded: P = { x | 0.5 <= x_1 <= 1, x_2 = 0 }
P = Polyhedron('H', [1 0 1; -1 0 -0.5; 0 1 0; 0 -1 0]);
assert(P.isBounded());

% unbounded: P = { x | x_1 <= 1, x_2 = 0 }
P = Polyhedron('H', [1 0 1; 0 1 0; 0 -1 0]);
assert(~P.isBounded());

% bounded: P = { x | x >= 0, x_1 + x_2 = 1 }
P = Polyhedron('H', [1 1 1; -1 -1 -1; -1 0 0; 0 -1 0]);
assert(P.isBounded());

% unbounded: P = { x | x >= 0, x_1 - x_2 = 1 }
P = Polyhedron('H', [1 -1 1; -1 1 -1; -1 0 0; 0 -1 0]);
assert(~P.isBounded());

% unbounded: P = { x | x_2 = 0 }
P = Polyhedron('H', [0 1 0; 0 -1 0]);
assert(~P.isBounded());

% single point is bounded
P = Polyhedron('H', [1 1; -1 -1]);
assert(P.isBounded());

end
