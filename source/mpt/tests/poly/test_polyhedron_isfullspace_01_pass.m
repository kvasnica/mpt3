function test_polyhedron_isfullspace_01_pass
% tests Polyhedron/isFullSpace()

%% R^n

% explicitly constructed R^n
R = Polyhedron.fullSpace(2);
assert(R.isFullSpace());

% H-rep of R^n
R = Polyhedron([0 0], 0);
assert(R.isFullSpace());
R = Polyhedron([0 0; 0 0], [0; 3]);
assert(R.isFullSpace());
R = Polyhedron([0 0], 2);
assert(R.isFullSpace());

% vertex + rays spanning R^n = R^n
R = Polyhedron('V', [1 0], 'R', [eye(2); -eye(2)]);
assert(R.isFullSpace());

% vertex + rays spanning R^n = R^n
R = Polyhedron('V', [1 0], 'R', [eye(2); -2*eye(2)]);
assert(R.isFullSpace());

% vertex + redundant rays spanning R^n = R^n
R = Polyhedron('V', [1 0], 'R', [eye(2); -eye(2); randn(5, 2)]);
assert(R.isFullSpace());

% vertex + different rays spanning R^n = R^n
R = Polyhedron('V', [1 0], 'R', [1 1; 1 -1; -1 1; -1 -1]);
assert(R.isFullSpace());

% no vertices and rays spanning R^n = R^n
R = Polyhedron('R', [eye(2); -eye(2)]);
assert(R.isFullSpace());

% no vertices and rays spanning R^n = R^n
R = Polyhedron('R', [1 0; 0 1; -1 -1]);
assert(R.isFullSpace());

% no vertices and different rays spanning R^n = R^n
R = Polyhedron('R', [1 1; 1 -1; -1 1; -2 -2]);
assert(R.isFullSpace());

% no vertices and redundant rays spanning R^n = R^n
R = Polyhedron('R', [eye(2); -eye(2); randn(5, 2)]);
assert(R.isFullSpace());

%% not R^n

% H-rep of an empty set is not R^n
R = Polyhedron([0 0; 0 0], [0; -1]);

% H-rep of a half-space is not R^n
R = Polyhedron([0 0; 0 1], [0; 0]);

% no vertices and rays spanning only a portion of R^n != R^n
R = Polyhedron('R', [1 1; 1 -1]);
assert(~R.isFullSpace());

% no vertices and rays spanning only a portion of R^n != R^n
R = Polyhedron('R', [1 1; 1 -1]);
assert(~R.isFullSpace());

% no vertices and rays spanning only a portion of R^n != R^n
R = Polyhedron('R', [1 0; -1 0]);
assert(~R.isFullSpace());

% no vertices and rays spanning only a portion of R^n != R^n
R = Polyhedron('R', [1 0; -1 0; 0 1]);
assert(~R.isFullSpace());

% no vertices and rays spanning only a portion of R^n != R^n
% (redundant rows here)
R = Polyhedron('R', [0 1; 0 -1; 1 0; 1 1]);
assert(~R.isFullSpace());

% no vertices and rays spanning only a portion of R^n != R^n
R = Polyhedron('R', [1 1; 2 -2]);
assert(~R.isFullSpace());

% no vertices and rays spanning only a portion of R^n != R^n
R = Polyhedron('R', [1 0; 0 1]);
assert(~R.isFullSpace());

% no vertices and rays spanning only a portion of R^n != R^n
% (redundant rows here)
R = Polyhedron('R', [1 1; 1 -1; rand(3, 2)]);
assert(~R.isFullSpace());

% no vertices and rays spanning only a portion of R^n != R^n
% (redundant rows here)
R = Polyhedron('R', [1 0; 0 1; rand(3, 2)]);
assert(~R.isFullSpace());

% polytope != R^n
R = Polyhedron.unitBox(2);
assert(~R.isFullSpace());

% positive orthant != R^n
R = Polyhedron(-eye(2), zeros(2, 1));
assert(~R.isFullSpace());

% negative orthant != R^n
% (redundant constraints
R = Polyhedron([eye(2); eye(2)], [zeros(2, 1); ones(2, 1)]);
assert(~R.isFullSpace());

% tilted halfspace != R^n
R = Polyhedron([1 1], 0);
assert(~R.isFullSpace());

% halfspace != R^n
R = Polyhedron([0 1], 1);
assert(~R.isFullSpace());

% positive orthant != R^n
R = Polyhedron('V', [0 1], 'R', eye(2));
assert(~R.isFullSpace());

% single ray in R^2 != R^n
R = Polyhedron('R', [1 0]);
assert(~R.isFullSpace());

% two linearly dependent rays in R^2 != R^n
R = Polyhedron('R', [1 0; -1 0]);
assert(~R.isFullSpace());

% cone in R^3 is not R^3
R = Polyhedron('R', [1 0 0; 0 0 1; 0 1 0; 0 -1 0]);
assert(~R.isFullSpace());

% empty set != R^n
R = Polyhedron.emptySet(2);
assert(~R.isFullSpace());

end
