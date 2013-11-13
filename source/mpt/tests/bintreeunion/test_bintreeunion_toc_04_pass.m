function test_bintreeunion_toc_04_pass
% LTI system in a single precision

% make sure we always delete temporary files upon exiting
file_name = 'test_bintreeunion_toc04';
c = onCleanup(@(x) cleanfiles(file_name));

model = LTISystem('A',[-0.2 1.8; -2.1 1.9],'B',[-0.5; 1.9]);
model.x.min = [-5; -4];
model.x.max = [6; 7];
model.u.min = -1.3;
model.u.max = 2;
model.x.penalty = QuadFunction(ones(2), [2, -2]);
model.u.penalty = QuadFunction(3, -1, 2);

ctrl = MPCController(model,3);
ectrl = ctrl.toExplicit;

% construct the tree
ectrl.optimizer = BinTreePolyUnion(ectrl.optimizer);

% export and test PWA function
ectrl.optimizer.toC('dual-ineqlin',file_name);
mex([file_name,'_mex.c']);

x = grid(ectrl.optimizer.convexHull,20);

for i=1:size(x,1)
   u1 = ectrl.optimizer.feval(x(i,:)','dual-ineqlin','tiebreak','obj');
   u2 = eval([file_name,'_mex(x(i,:)'')']);
   if norm(u1-u2,Inf)>1e-6
       error('The PWA function value does not hold for the row %d.',i);
   end        
end


end



function cleanfiles(fname)

clear('functions');
delete([fname,'_mex.',mexext]);
delete([fname,'.c']);
delete([fname,'_mex.c']);

end