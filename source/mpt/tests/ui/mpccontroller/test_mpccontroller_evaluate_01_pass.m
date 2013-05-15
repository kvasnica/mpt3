function test_mpccontroller_evaluate_01_pass
% tests MPCController/evaluate

Double_Integrator
probStruct.norm = 2;
probStruct.Tconstraint = 0; probStruct.P_N = eye(2);
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);

% one output
ugood = -1;
u = M.evaluate([4; 0]);
assert(norm(u-ugood)<1e-8);

% two outputs
ugood = -1;
[u, feasible] = M.evaluate([4; 0]);
assert(norm(u-ugood)<1e-8);
assert(feasible);

% infeasible, one output
u = M.evaluate([100; 100]);
assert(isnan(u));

% infeasible, two outputs
[u, feasible] = M.evaluate([100; 100]);
assert(isnan(u));
assert(~feasible);

% open-loop sequence
Ugood = [-1 -1 0.177664974619288 0.477157360406091 0.340101522842639];
Xgood = [4 3 1.5 0.677664974619288 0.243654822335022 -0.0888324873096492;0 -0.5 -1 -0.911167512690356 -0.672588832487311 -0.502538071065991];
Ygood = [4 3 1.5 0.677664974619288 0.243654822335022;0 -0.5 -1 -0.911167512690356 -0.672588832487311];
Jgood = 32.9365482233503;
[u, feasible, openloop] = M.evaluate([4; 0]);
assert(norm(u-Ugood(1))<1e-6);
assert(feasible);
assert(norm(openloop.U-Ugood)<1e-6);
assert(norm(openloop.X-Xgood)<1e-6);
assert(norm(openloop.Y-Ygood)<1e-6);
assert(norm(openloop.cost-Jgood)<1e-6);

% check that we automatically re-create the optimizer upon modification of
% the model and/or the prediction horizon
M.N = 3;
Ugood = [-1 -1 0];
Xgood = [4 3 1.5 0.499999999999999;0 -0.5 -1 -1];
Ygood = [4 3 1.5;0 -0.5 -1];
Jgood = 31.75;
[~, ~, openloop] = M.evaluate([4; 0]);
assert(norm(openloop.U-Ugood)<1e-6);
assert(norm(openloop.X-Xgood)<1e-6);
assert(norm(openloop.Y-Ygood)<1e-6);
assert(norm(openloop.cost-Jgood)<1e-6);

M.model.u.min = -0.8;
[~, ~, openloop] = M.evaluate([4; 0]);
Ugood = [-0.8 -0.8 -0.355555555555557];
Jgood = 34.1155555555556;
assert(norm(openloop.U-Ugood)<1e-6);
assert(norm(openloop.cost-Jgood)<1e-6);

end
