function test_voronoi_03_pass
% 2D points

% no bounds
S = randn(2, 10);
V = mpt_voronoi(S);
assert(isa(V, 'PolyUnion'));
assert(V.Num==size(S, 2));
assert(V.Dim==size(S, 1));
assert(V.Internal.Convex);
assert(~V.Internal.Overlaps);
assert(V.Internal.Connected);

% double-check that we have correct properties
assert(PolyUnion(V.Set).isConvex);
assert(~PolyUnion(V.Set).isOverlapping);
assert(PolyUnion(V.Set).isConnected);

% i-th point must be contained only in the i-th cells
for i = 1:size(S, 2)
	c = V.Set.contains(S(:, i));
	assert(c(i));
	assert(~any(c(setdiff(1:size(S, 2), i))));
end

end
