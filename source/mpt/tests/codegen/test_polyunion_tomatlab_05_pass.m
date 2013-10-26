function test_polyunion_tomatlab_05_pass
% multiple PWQ optimizers, quadratic tiebreak

c = onCleanup(@() delete('pu_export.m'));

opt_sincos
probStruct.Tconstraint=0;
probStruct.norm=2;
probStruct.N=2;
ctrl = EMPCController(mpt_import(sysStruct, probStruct), 3);
assert(numel(ctrl.optimizer)>1);

% quadratic tiebreak
ctrl.optimizer.toMatlab('pu_export', 'primal', 'obj');
pause(0.1);
rehash
pause(0.1);
% double-check that values are identical to PolyUnion/feval
X = grid(Polyhedron.unitBox(2)*8, 10);
for i = 1:size(X, 1)
	x = X(i, :)';
	[~, ~, p1] = ctrl.evaluate(x);
	p2 = pu_export(x);
	assert(norm(p1.U(:)-p2)<1e-8); % optimizers must be identical
end

end
