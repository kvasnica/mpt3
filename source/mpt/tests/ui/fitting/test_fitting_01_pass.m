function test_fitting_01_pass
% tests FittingController() and FittingController/evaluate()

Double_Integrator
probStruct.Tconstraint = 0;
probStruct.P_N = eye(2);
sysStruct.ymax = [10; 5];
sysStruct.ymin = [-10; -5];
model = mpt_import(sysStruct, probStruct);
ctrl = EMPCController(model, probStruct.N);

Nempc = 43;
Nfit = 7;

% construct the fitting controller
fit = FittingController(ctrl);
assert(fit.nr == Nfit);
assert(fit.optimizer.Num == fit.nr);
% the original controller must stay unchanged
assert(ctrl.nr == Nempc);

% test evaluation
X = fit.optimizer.convexHull.grid(20);
u_empc = zeros(1, size(X, 1));
t=clock;
for i = 1:size(X, 1),
	u_empc(i) = ctrl.evaluate(X(i, :)');
end
etime(clock, t)
t=clock;
for i = 1:size(X, 1),
	u_fit = fit.evaluate(X(i, :)');
end,
etime(clock, t)

end
