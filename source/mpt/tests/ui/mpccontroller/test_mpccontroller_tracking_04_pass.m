function test_mpccontroller_tracking_04_pass
% PWA, output tracking (no integrator)

opt_sincos
probStruct.N = 10;
sysStruct.C = { [1 0], [1 0] };
sysStruct.D = { 0, 0 };
sysStruct.ymax = sysStruct.ymax(1);
sysStruct.ymin = sysStruct.ymin(1);
model = mpt_import(sysStruct, probStruct);
x0 = [0; 0];
yref = 1;

model.x.penalty = [];
model.y.penalty = OneNormFunction(2);
model.y.with('reference');
model.y.reference = 'free';
ctrl = MPCController(model, probStruct.N);

[u, feasible, openloop] = ctrl.evaluate(x0, 'y.reference', yref);
Jgood = 13.7169504172281;
ugood = -1;
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assertwarning(abs(u - ugood) <= 1e-8);

% the same result must be obtained by setting the references to fixed
% values
ctrl.model.y.reference = yref;
[u, feasible, openloop] = ctrl.evaluate(x0, 'y.reference', yref);
ugood = -1;
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assertwarning(abs(u - ugood) <= 1e-8);

end
