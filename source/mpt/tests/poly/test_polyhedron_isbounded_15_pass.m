function test_polyhedron_isbounded_15_pass
% boundedness check for lower-dimensional polyhedra (issue #112)

% bounded: P = { x | 0.5 <= x_1 <= 1, x_2 = 0 }
P = Polyhedron('H', [1 0 1; -1 0 -0.5], 'He', [0 1 0]);
assert(P.isBounded());

% unbounded: P = { x | x_1 <= 1, x_2 = 0 }
P = Polyhedron('H', [1 0 1], 'He', [0 1 0]);
assert(~P.isBounded());

% bounded: P = { x | x >= 0, x_1 + x_2 = 1 }
P = Polyhedron('He', [1 1 1], 'lb', [0; 0]);
assert(P.isBounded());

% unbounded: P = { x | x >= 0, x_1 - x_2 = 1 }
P = Polyhedron('He', [1 -1 1], 'lb', [0; 0]);
assert(~P.isBounded());

% unbounded: P = { x | x_2 = 0 }
P = Polyhedron('He', [0 1 0]);
assert(~P.isBounded());

% single point is bounded
P = Polyhedron('Ae',[-1 -0.4;0 3.1],'be',[-0.1;0.5],'lb',[-2;-3],'ub',[2;3]);
assert(P.isBounded());

end
