function test_polyunion_outerapprox_05_pass
% outer approximation with unbounded regions (issue #125)

% x<=1 \cup x>=1 is R^1
P1 = Polyhedron('lb', 1);
P2 = Polyhedron('ub', 1);
U = PolyUnion([P1 P2]);
B = U.outerApprox();
assert(B.isFullSpace());
assert(B.Internal.lb==-Inf);
assert(B.Internal.ub==Inf);

% x>=1 \cup x>=2 is x>=1
P1 = Polyhedron('lb', 1);
P2 = Polyhedron('lb', 2);
U = PolyUnion([P1 P2]);
B = U.outerApprox();
assert(B.Internal.lb==1);
assert(B.Internal.ub==Inf);
assert(B==P1);

% x<=1 \cup x<=0 is x<=1
P1 = Polyhedron('ub', 1);
P2 = Polyhedron('ub', 0);
U = PolyUnion([P1 P2]);
B = U.outerApprox();
assert(B.Internal.lb==-Inf);
assert(B.Internal.ub==1);
assert(B==P1);

end
