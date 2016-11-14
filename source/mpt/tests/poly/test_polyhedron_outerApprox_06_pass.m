function test_polyhedron_outerApprox_06_pass
% unbounded sets have unbounded outer approximations

% unbounded above
P = Polyhedron('lb', 1);
B = P.outerApprox();
assert(B.Internal.lb==1);
assert(B.Internal.ub==Inf);
assert(P.Internal.lb==1);
assert(P.Internal.ub==Inf);

% unbounded below
P = Polyhedron('ub', 2);
B = P.outerApprox();
assert(B.Internal.lb==-Inf);
assert(B.Internal.ub==2);
assert(P.Internal.lb==-Inf);
assert(P.Internal.ub==2);

% unbounded in all directions
P = Polyhedron.fullSpace(1);
B = P.outerApprox();
assert(B.Internal.lb==-Inf);
assert(B.Internal.ub==Inf);
assert(P.Internal.lb==-Inf);
assert(P.Internal.ub==Inf);

end
