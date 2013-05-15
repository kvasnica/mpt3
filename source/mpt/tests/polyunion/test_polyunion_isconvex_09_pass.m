function test_polyunion_isconvex_09_pass
%
% convexity recognition with lower-dimensional sets

% union of these two line segments in 2D is convex
P1 = Polyhedron([0 1; 1 1]).minHRep();
P2 = Polyhedron([1 1; 2 1]).minHRep();
U = PolyUnion([P1 P2]);
assert(U.isConvex());

% union of these two is not convex
P1 = Polyhedron([0 1; 1 1]).minHRep();
P2 = Polyhedron([1.5 1; 2 1]).minHRep();
U = PolyUnion([P1 P2]);
assert(~U.isConvex());
