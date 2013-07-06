function test_separation_01_pass
% tests SeparationController() and SeparationController/evaluate()

Double_Integrator
probStruct.Tconstraint = 0;
probStruct.P_N = eye(2);
sysStruct.ymax = [10; 5];
sysStruct.ymin = [-10; -5];
model = mpt_import(sysStruct, probStruct);
ctrl = EMPCController(model, probStruct.N);

Nempc = 43;
Nsep = 11;

% construct the separation controller
sep = SeparationController(ctrl);
assert(sep.nr == Nsep);
assert(sep.optimizer.Num == sep.nr);
% the original controller must stay unchanged
assert(ctrl.nr == Nempc);

% test evaluation
X = ctrl.optimizer.convexHull.grid(20);
u_empc = zeros(1, size(X, 1));
t=clock;
for i = 1:size(X, 1),
	u_empc(i) = ctrl.evaluate(X(i, :)');
end
etime(clock, t)
t=clock;
for i = 1:size(X, 1),
	u_sep = sep.evaluate(X(i, :)');
	assert(norm(u_empc(i) - u_sep, Inf) <= 1e-6);
end,
etime(clock, t)

end
