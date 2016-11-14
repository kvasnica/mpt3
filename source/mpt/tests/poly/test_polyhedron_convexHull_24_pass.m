function test_polyhedron_convexHull_24_pass
% convex hull of half-spaces (issue #75)

%% union is not convex
P1=Polyhedron([-1 -1], 0); 
P2=Polyhedron([-1 1], 0);

% compute convex hull
H = PolyUnion([P1 P2]).convexHull();
assert(numel(H)==1);

% the union must contain P1 and P2
assert(H.contains(P1));
assert(H.contains(P2));

% the hull must be R^2
assert(H.isFullSpace);
assert(~H.isEmptySet);
assert(H.isFullDim);
assert(~H.isBounded);
assert(H.Dim==2);

%% union is convex
%P1=Polyhedron([0 1], 0); 
P1=Polyhedron('A', [0 1], 'b', 0, 'V', [0 0], 'R', [0 -1; 1 0]); 
P2=Polyhedron([0 1], -1);

% compute convex hull
H = PolyUnion([P1 P2]).convexHull();

% the hull must contain P1 and P2
assert(H.contains(P1));
assert(H.contains(P2));

assert(isempty(H.V)); % no vertices here!
assert(numel(H)==1);
assert(H==P1); % this check is useless if the vertices are non-empty
% better test for H==P1
assert(isEmptySet(H\P1));
assert(isEmptySet(P1\H));

end
