function test_empccontroller_bintree_01_pass
% tests EMPCController.binaryTree()

Double_Integrator
probStruct.Tconstraint=0;
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, 2);
assert(E.nr==3);

% must create a copy of E
T = E.binaryTree();
assert(~isa(E.optimizer, 'BinTreePolyUnion'));
assert(isa(T.optimizer, 'BinTreePolyUnion'));

% must do in-place replacement
E.binaryTree();
assert(isa(E.optimizer, 'BinTreePolyUnion'));

end
