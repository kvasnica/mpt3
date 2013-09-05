function test_polyunion_isconvex_10_pass
% non-convex union of two half-spaces (issue #75)

P1 = Polyhedron([-1 -1], 0); 
P2 = Polyhedron([-1 1], 0);
U = PolyUnion([P1 P2]);

% the union is not convex
assert(~U.isConvex);

end
