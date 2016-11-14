function test_empccontroller_evaluate_02_pass
% tests MPCController/evaluate (PWA)

opt_sincos
probStruct.N = 3;
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N).toExplicit();

% open-loop sequence
Ugood = [-1 -1 0];
Jgood = 8.58830632579836;
[u, feasible, openloop] = M.evaluate([4; 0]);
assert(feasible);
assert(norm(u-Ugood(:, 1))<1e-6);
assert(norm(openloop.cost-Jgood)<1e-6);
assert(~any(any(isnan(openloop.U))));
assert(isequal(size(openloop.U), [model.nu, probStruct.N]));
assert(isequal(size(openloop.U), [model.nu probStruct.N]));
assert(all(all(isnan(openloop.X)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.X), [model.nx probStruct.N+1]));
assert(all(all(isnan(openloop.Y)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.Y), [model.ny probStruct.N]));

% test infeasibility
[u, feasible, openloop] = M.evaluate([100; 100]);
assert(~feasible);
assert(isnan(u));
assert(openloop.cost==Inf);
assert(all(all(isnan(openloop.U))));
assert(isequal(size(openloop.U), [model.nu, probStruct.N]));
assert(isequal(size(openloop.U), [model.nu probStruct.N]));
assert(all(all(isnan(openloop.X)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.X), [model.nx probStruct.N+1]));
assert(all(all(isnan(openloop.Y)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.Y), [model.ny probStruct.N]));

end
