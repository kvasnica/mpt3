function test_empccontroller_evaluate_01_pass
% tests MPCController/evaluate (LTI)

Double_Integrator
probStruct.norm = 2;
probStruct.Tconstraint = 0; probStruct.P_N = eye(2);
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N).toExplicit();
assert(M.isExplicit);

% one output argument
ugood = -1;
u = M.evaluate([4; 0]);
assert(norm(u-ugood)<1e-6);

% two output arguments
ugood = -1;
[u, feasible] = M.evaluate([4; 0]);
assert(feasible);
assert(norm(u-ugood)<1e-6);

% open-loop sequence
Ugood = [-1 -1 0.177664974619288 0.477157360406091 0.340101522842639];
Jgood = 32.9365482233503;
[~, ~, openloop] = M.evaluate([4; 0]);
assert(norm(openloop.U-Ugood)<1e-6);
assert(norm(openloop.cost-Jgood)<1e-6);
assert(all(all(isnan(openloop.X)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.X), [model.nx probStruct.N+1]));
assert(all(all(isnan(openloop.Y)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.Y), [model.ny probStruct.N]));

% now test infeasibility
u = M.evaluate([100; 100]);
assert(isnan(u));

[u, feasible] = M.evaluate([100; 100]);
assert(~feasible);
assert(isnan(u));

[~, ~, openloop] = M.evaluate([100; 100]);
assert(openloop.cost==Inf);
assert(all(isnan(openloop.U)));
assert(isequal(size(openloop.U), [model.nu probStruct.N]));
assert(all(all(isnan(openloop.X)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.X), [model.nx probStruct.N+1]));
assert(all(all(isnan(openloop.Y)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.Y), [model.ny probStruct.N]));

end
