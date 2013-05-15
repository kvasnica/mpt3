function test_empcstcontroller_evaluate_02_pass
% test export to search tree
% third order model
%

ThirdOrder;

model = mpt_import(sysStruct,probStruct);

ctrl = MPCController(model, 6);

ectrl = ctrl.toExplicit;

% export to search tree
cst = ectrl.toSearchTree;

% evaluate using both methods and compare
X = grid(ectrl.optimizer.Internal.convexHull,10);

for i=1:size(X,1)
   f1 = ectrl.evaluate(X(i,:));
   f2 = cst.evaluate(X(i,:));
   
   if any(isnan(f2))
       erro('Wrong region identification');
   end
   
   if norm(f1-f2,Inf)>1e-5
       error('The evaluation does not hold.');
   end
    
end


end
