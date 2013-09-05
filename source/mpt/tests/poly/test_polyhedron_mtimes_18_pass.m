function test_polyhedron_mtimes_18_pass
% scaling with zero should produce a lower-dimension set

% scaling of R^n with zero should also produce a singleton (depends on
% resolution of issue #93)
P = Polyhedron(0, 1);
Q = 0*P;
assert(Q.hasHRep); % same representation as input
assert(~Q.hasVRep);
assert(~Q.isEmptySet);
assert(~Q.isFullDim);
assert(isequal(Q.V, 0));

P = Polyhedron('R', eye(2));
Q = 0*P;
assert(Q.hasVRep); % same representation as input
assert(~Q.hasHRep);
assert(~Q.isEmptySet);
assert(~Q.isFullDim);
assert(isequal(Q.V, [0 0]));

end
