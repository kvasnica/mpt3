function test_polyunion_convexhull_06_pass
% special union of two half-spaces which is R^n

P1 = Polyhedron([-1 -1], 0); 
P2 = Polyhedron([-1 1], 0);
U = PolyUnion([P1 P2]);
H = U.convexHull();

% the convex hull is R^2
assert(~H.isEmptySet);
assert(H.isFullDim);
assert(~H.isBounded);
assert(H.Dim==2);

% since the hull is R^2, it must contain a large box
B = Polyhedron('lb', -9999*ones(2, 1), 'ub', 9999*ones(2, 1));
assert(H.contains(B));

% more strict testing of whether H is indeed R^2
assert(isequal(H.H, [0 0 1]));
assert(isempty(H.He));

end
