function test_bintreeunion_02_pass
% synthetic 2D example

P1 = Polyhedron([0 0; 3.5 1.5; 2 0; 2.5 6; 0 6]);
P2 = Polyhedron([2.5 6; 3.5 1.5; 8 6]);
P3 = Polyhedron([2 0; 7 0; 6 4]);
P4 = Polyhedron([6 4; 8 6; 10 6; 10 2; 6.5 2]);
P5 = Polyhedron([6.5 2; 7 0; 10 0; 10 2]);
U = PolyUnion([P1 P2 P3 P4 P5]);

% regions must not overlap
assert(~U.isOverlapping);
% union must be equal to H
H = Polyhedron('lb', [0; 0], 'ub', [10; 6]);
assert(U.convexHull == H);

%% construct the tree
t = BinTreePolyUnion(U);
% check data (4 candidates for separating hyperplanes)
assert(size(t.Internal.BinaryTree.H, 1)==4)
% depth=3
assert(t.Internal.BinaryTree.depth==3);
% 7 nodes
assert(t.Internal.BinaryTree.n_nodes==5);

%% test point location
% make regions a bit smaller to avoid points on facets
B = Polyhedron('lb', -1e-3*ones(2, 1), 'ub', 1e-3*ones(2, 1));
R = U.Set-B;
for i = 1:U.Num
	x = R(i).grid(20);
	for j = 1:size(x, 1)
		% each point must be contained in the i-th region
		[isin, inwhich] = t.contains(x(j, :)');
		assert(isin);
		assert(inwhich==i);
	end
end

end
