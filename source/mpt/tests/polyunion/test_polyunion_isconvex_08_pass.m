function test_polyunion_isconvex_08_pass
% convexity check with lower-dimensional polytopes

% union of these two is not convex
P=Polyhedron('lb',[0;0],'ub',[1;1]);
Q=Polyhedron('V',[1 0;2 1]);
assert(~PolyUnion([P Q]).isConvex);

% union of these two is convex
P=Polyhedron('lb',[0;0],'ub',[1;1]);
Q=Polyhedron('V',[1 0;0 1]);
assert(PolyUnion([P Q]).isConvex);

end
