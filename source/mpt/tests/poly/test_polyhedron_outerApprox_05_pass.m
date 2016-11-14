function test_polyhedron_outerApprox_05_pass
% outer approximation of an empty set must be an empty set

% x <= 1, x >= 2 is an empty set
P = Polyhedron([1; -1], [1; -2]);
B = P.outerApprox();
assert(P.isEmptySet());
assert(B.isEmptySet());
assert(B.Dim==P.Dim);
assert(B.Internal.lb == Inf);
assert(B.Internal.ub == -Inf);

end
