function test_empcstcontroller_evaluate_01_pass
% test export to search tree
% double integrator example
%

Double_Integrator;

model = mpt_import(sysStruct,probStruct);

ctrl = MPCController(model, 3);

ectrl = ctrl.toExplicit;

% export to search tree
cst = ectrl.toSearchTree;

% evaluate using both methods and compare
X = grid(ectrl.optimizer.Internal.convexHull,20);

for i=1:size(X,1)
   f1 = ectrl.evaluate(X(i,:)');
   f2 = cst.evaluate(X(i,:)');
   
   if any(isnan(f2))
       error('Wrong region identification.');
   end
   
   if norm(f1-f2,Inf)>1e-5
       error('The evaluation does not hold.');
   end
    
end


end
