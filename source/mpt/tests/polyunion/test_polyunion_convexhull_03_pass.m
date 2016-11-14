function test_polyunion_convexhull_03_pass
%
% convex hull of an array of unions must produce a single hull
%

P = Polyhedron('lb', -1, 'ub', 1);
U1 = PolyUnion(P);
P1 = Polyhedron('lb', 0.1, 'ub', 0.3);
P2 = Polyhedron('lb', 0.4, 'ub', 2);
U2 = PolyUnion([P1 P2]);
U = [U1 U2];

% direct computation
H = U.convexHull();
G = Polyhedron('lb', -1, 'ub', 2);
assert(H==G);

% alternative computation
H = PolyUnion([P, P1, P2]).convexHull;
G = Polyhedron('lb', -1, 'ub', 2);
assert(H==G);

end
