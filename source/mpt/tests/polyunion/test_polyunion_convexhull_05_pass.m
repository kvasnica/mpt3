function test_polyunion_convexhull_05_pass
% tests PolyUnion/convexHull

P1 = Polyhedron([eye(2); -eye(2)], [0; 0; 1; 1]);
P2 = Polyhedron([eye(2); -eye(2)], [1; 1; 0; 0]);
Hgood = Polyhedron('H', [1 -1 1;-0 -1 1;-1 -0 1;-1 1 1;-0 1 1;1 -0 1]);

% no internal data by default
U = PolyUnion([P1 P2]);
assert(~isfield(U.Internal, 'convexHull') || isempty(U.Internal.convexHull));

% check the computed convex hull
H = U.convexHull;
assert(H==Hgood);
assert(isa(U.Internal.convexHull, 'Polyhedron'));
assert(length(U.Internal.convexHull)==1);
assert(U.Internal.convexHull==H);

% should return the stored value
H = U.convexHull;
assert(H==Hgood);
assert(isa(U.Internal.convexHull, 'Polyhedron'));
assert(length(U.Internal.convexHull)==1);
assert(U.Internal.convexHull==H);

% in-place storage
U = PolyUnion([P1 P2]);
U.convexHull;
assert(isa(U.Internal.convexHull, 'Polyhedron'));
assert(length(U.Internal.convexHull)==1);
assert(U.Internal.convexHull==Hgood);

end
