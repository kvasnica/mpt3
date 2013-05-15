function test_empcstcontroller_01_pass
% test export to search tree
% double integrator example
%

Double_Integrator;

model = mpt_import(sysStruct,probStruct);

ctrl = MPCController(model, 3);

ectrl = ctrl.toExplicit;

% export to search tree
c1 = ectrl.toSearchTree;

% direct construction
c2 = EMPCSTController(ectrl);

% compare the tree data
if ~isequal(c1.STdata,c2.STdata)
    error('The data must be equal.');
end


end
