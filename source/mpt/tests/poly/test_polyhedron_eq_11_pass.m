function test_polyhedron_eq_11_pass
% test lower-dimensional polytopes

% union of these two is not convex
P=Polyhedron('lb',[0;0],'ub',[1;1]);
Q=Polyhedron('V',[1 0; 2 1]);
H = PolyUnion([P Q]).convexHull;
answer = (H==[P Q]);
assert(isequal(size(answer), [1 1]));
assert(~answer);

% two splitted line segments in 2D are equal to the whole
P1 = Polyhedron([0 1; 0.5 1]);
P2 = Polyhedron([0.5 1; 1 1]);
P3 = Polyhedron([0 1; 1 1]);
answer = (P3==[P1 P2]);
assert(isequal(size(answer), [1 1]));
assert(answer);

end
