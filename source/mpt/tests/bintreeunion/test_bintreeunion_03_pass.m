function test_bintreeunion_03_pass
% double-integrator eMPC partition

Double_Integrator
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, probStruct.N);
assert(E.nr==25);

%% construct the tree
Tree = BinTreePolyUnion(E.optimizer);
% check data (38 candidates for separating hyperplanes)
assert(size(Tree.Internal.BinaryTree.H, 1)==38)
% depth=8
assert(Tree.Internal.BinaryTree.depth==8);
% 81 nodes
assert(Tree.Internal.BinaryTree.n_nodes==65);

%% test point location
% make regions a bit smaller to avoid points on facets
B = Polyhedron('lb', -1e-3*ones(2, 1), 'ub', 1e-3*ones(2, 1));
R = E.optimizer.Set-B;
for i = 1:numel(R)
	x = R(i).grid(10);
	for j = 1:size(x, 1)
		% each point must be contained in the i-th region
		[isin, inwhich] = Tree.contains(x(j, :)');
		assert(isin);
		assert(inwhich==i);
	end
end

%% test evaluation:
% E.optimizer.feval()
% Tree.feval()
% EMPCController.evaluate() for the tree-based optimizer
E_tree = E.copy();
E_tree.optimizer = Tree;
for i = 1:numel(R)
	x = R(i).grid(10);
	for j = 1:size(x, 1)
		f_orig = E.optimizer.feval(x(j, :)', 'primal', 'tiebreak', 'obj');
		f_tree = Tree.feval(x(j, :)', 'primal', 'tiebreak', 'obj');
		[~, ~, ol] = E_tree.evaluate(x(j, :)');
		f_treempc = ol.U(:);
		assert(isequal(f_orig, f_tree));
		assert(isequal(f_orig, f_treempc));
	end
end

%% test getFunction
feedback = Tree.getFunction('primal');
assert(isa(feedback, 'BinTreePolyUnion'));
assert(feedback.hasFunction('primal'));
assert(~feedback.hasFunction('obj'));
assert(feedback.Num==Tree.Num);

end
