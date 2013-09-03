function test_polyhedron_ispointed_02_pass
% tests for Polyhedron/isPointed with V-polyhedra

% polytope is pointed
P = Polyhedron([-1 -1; -1 1; 1 -1; 1 1]);
assert(P.isPointed());
assert(~P.hasHRep); % no conversion to H-rep!

% positive orthant is pointed
P = Polyhedron('V', [0 0], 'R', [1 0; 0 1]);
assert(P.isPointed());
assert(~P.hasHRep); % no conversion to H-rep!

% shifted positive orthant is pointed
P = Polyhedron('V', [1 1], 'R', [1 0; 0 1]);
assert(P.isPointed());
assert(~P.hasHRep); % no conversion to H-rep!

% affine set represented by a single ray with no vertices is not pointed
P = Polyhedron('R', [1 0]);
assert(~P.isPointed());
assert(~P.hasHRep); % no conversion to H-rep!

% R^n is not pointed
P = Polyhedron('R', [eye(2); -eye(2)]);
assert(~P.isPointed());
assert(~P.hasHRep); % no conversion to H-rep!

end
