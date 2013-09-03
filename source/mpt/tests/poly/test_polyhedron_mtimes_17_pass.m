function test_polyhedron_mtimes_17_pass
% scaling with zero should produce a lower-dimension set

P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q = 0*P; % the result is just a single vertex at zeros(dim, 1)
assert(Q.hasHRep); % same representation as input
assert(~Q.hasVRep);
assert(~Q.isEmptySet);
assert(~Q.isFullDim);
assert(isequal(Q.V, zeros(1, 2)));
assert(isempty(Q.R));
assert(Q.contains(zeros(2, 1)));
assert(~Q.contains(zeros(2,1)+1e-4));

P = Polyhedron([1 1; 1 -1; -1 1; -1 -1]);
Q = 0*P; % the result is just a single vertex at zeros(dim, 1)
assert(Q.hasVRep); % same representation as input
assert(~Q.hasHRep);
assert(~Q.isEmptySet);
assert(~Q.isFullDim);
assert(isequal(Q.V, zeros(1, 2)));
assert(isempty(Q.R));
assert(Q.contains(zeros(2, 1)));
assert(~Q.contains(zeros(2,1)+1e-4));

% scaling of R^n with zero should also produce a singleton (depends on
% resolution of issue #93)
P = Polyhedron(0, 1);
Q = 0*P;
assert(~Q.isEmptySet);
assert(~Q.isFullDim);
assert(isequal(Q.V, 0));

end
