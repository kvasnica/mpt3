function test_bintreeunion_tomatlab_03_pass
% single PWQ optimizer as a binary tree

c = onCleanup(@() delete('pu_export.m'));

Double_Integrator
probStruct.Tconstraint=0;
ctrl = EMPCController(mpt_import(sysStruct, probStruct), 4);
tree = BinTreePolyUnion(ctrl.optimizer);

% PWQ function
tree.toMatlab('pu_export', 'obj');
pause(0.1);
rehash
pause(0.1);
% double-check that values are identical to PolyUnion/feval
X = ctrl.optimizer.Domain.grid(10);
for i = 1:size(X, 1)
	x = X(i, :)';
	[p1, ~, r1] = ctrl.optimizer.feval(x, 'obj', 'tiebreak', @(x) 0);
	[p2, r2] = pu_export(x);
	assert(r1==r2); % regions must be the same
	assert(norm(p1-p2)<1e-8); % optimizers must be identical
end

end