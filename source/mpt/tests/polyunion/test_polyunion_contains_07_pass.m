function test_polyunion_contains_07_pass
%
% 1D-polyhedron, H-rep, fast abort via convex hull
%

P = Polyhedron('lb', -1, 'ub', 1);
Q = PolyUnion([P P]);
Q.convexHull;

% point inside
x = 0;
[isin, inwhich, closest] = Q.contains(x);
assert(isin);
assert(isequal(inwhich, [1 2]));
assert(isempty(closest));

% point outside
x = 2;
[isin, inwhich] = Q.contains(x);
assert(~isin);
assert(isempty(inwhich));
[isin, inwhich, closest] = Q.contains(x);
assert(~isin);
assert(isempty(inwhich));
assert(closest==1);

end
