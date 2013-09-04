function test_polyhedron_ispointed_02_pass
% tests for Polyhedron/isPointed with V-polyhedra

% polytope is pointed
P = Polyhedron([-1 -1; -1 1; 1 -1; 1 1]);
assert(P.isPointed());

% positive orthant is pointed
P = Polyhedron('V', [0 0], 'R', [1 0; 0 1]);
assert(P.isPointed());

% shifted positive orthant is pointed
P = Polyhedron('V', [1 1], 'R', [1 0; 0 1]);
assert(P.isPointed());

% polyhedron -1 <= x(1) <= 1, x(2)>=0 is pointed
V = [-1 0; 1 0];
R = [0 1];
P = Polyhedron('V', V, 'R', R);
assert(P.isPointed());

% affine set represented by a single ray with no vertices is pointed 
% (because the zero vertex is implicitly added)
P = Polyhedron('R', [1 0]);
assert(P.isPointed());

% a slab -1 <= x(1) <= 1, x(2) arbitrary, is not pointed
V = [-1 0; 1 0];
R = [0 1; 0 -1];
P = Polyhedron('V', V, 'R', R);
assert(~P.isPointed());

% R^n is not pointed
P = Polyhedron('R', [eye(2); -eye(2)]);
assert(~P.isPointed());

end
