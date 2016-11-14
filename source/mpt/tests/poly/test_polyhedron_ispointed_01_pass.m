function test_polyhedron_ispointed_01_pass
% tests for Polyhedron/isPointed

% polytope is pointed
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
assert(P.isPointed());
assert(~P.hasVRep); % no conversion to V-rep!

% positive orthant is pointed
P = Polyhedron(-eye(2), zeros(2, 1));
assert(P.isPointed());
assert(~P.hasVRep); % no conversion to V-rep!

% shifted positive orthant is pointed
P = Polyhedron(-eye(2), -ones(2, 1));
assert(P.isPointed());
assert(~P.hasVRep); % no conversion to V-rep!

% { (x, y, z) | |x|<=z, |y|<=z } is pointed
A = [1 0 -1; -1 0 -1; 0 1 -1; 0 -1 -1]; b = zeros(4, 1);
P = Polyhedron(A, b);
assert(P.isPointed());
assert(~P.hasVRep); % no conversion to V-rep!

% a slab -1 <= a'*x <= 1 is not pointed
a = randn(1, 2);
P = Polyhedron([a; -a], [1; 1]);
assert(~P.isPointed());
assert(~P.hasVRep); % no conversion to V-rep!

% half-space is not pointed
P = Polyhedron([0 1], 0);
assert(~P.isPointed());
assert(~P.hasVRep); % no conversion to V-rep!

% shifted half-space is not pointed
P = Polyhedron([0 1], -1);
assert(~P.isPointed());
assert(~P.hasVRep); % no conversion to V-rep!

end
