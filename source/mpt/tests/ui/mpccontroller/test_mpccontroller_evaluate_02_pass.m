function test_mpccontroller_evaluate_02_pass
% tests MPCController/evaluate (PWA)

opt_sincos
probStruct.N = 3;
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);

% open-loop sequence
Ugood = [-1 -1 0];
Jgood = 8.58830632579836;
Xgood = [4 1.6 -0.587179676972449 0.331179676972449;0 1.7712812921102 0.817025033688163 0.73362002695053];
Ygood = [4 1.6 -0.587179676972449;0 1.7712812921102 0.817025033688163];
[u, feasible, openloop] = M.evaluate([4; 0]);
assertwarning(norm(openloop.U-Ugood)<1e-6); % gurobi gives a different optimizer
assertwarning(norm(openloop.X-Xgood)<1e-6); 
assertwarning(norm(openloop.Y-Ygood)<1e-6);
assert(norm(openloop.cost-Jgood)<1e-6); % but cost must always be the same

% only one output argument
u = M.evaluate([4; 0]);
assertwarning(norm(u-Ugood(:, 1))<1e-6);

% test infeasibility
u = M.evaluate([100; 100]);
assert(isnan(u));
[u, feasible] = M.evaluate([100; 100]);
assert(isnan(u));
assert(~feasible);
[u, feasible, openloop] = M.evaluate([100; 100]);
assert(isnan(u));
assert(~feasible);
assert(openloop.cost==Inf);
assert(all(all(isnan(openloop.X))));
assert(all(all(isnan(openloop.U))));
assert(all(all(isnan(openloop.Y))));


% check that we automatically re-create the optimizer upon modification of
% the model and/or the prediction horizon
M.N = 4;
Ugood = [-1 -1 -0.40244034997808 0];
Xgood = [4 1.6 -0.587179676972447 0.331179676972449 -0.0969761399912308;0 1.7712812921102 0.817025033688161 0.331179676972449 0.36191988156919];
Ygood = [4 1.6 -0.587179676972447 0.331179676972448;0 1.7712812921102 0.817025033688161 0.331179676972448];
Jgood = 9.32192635274889;
[~, ~, openloop] = M.evaluate([4; 0]);
assertwarning(norm(openloop.U-Ugood)<1e-6);
assertwarning(norm(openloop.X-Xgood)<1e-6);
assertwarning(norm(openloop.Y-Ygood)<1e-6);
assert(norm(openloop.cost-Jgood)<1e-6);

M.model.u.min = -0.8;
[~, ~, openloop] = M.evaluate([4; 0]);
Ugood = [-0.8 -0.8 -0.47187628537257 0];
Jgood = 9.60992635274889;
assertwarning(norm(openloop.U-Ugood)<1e-6);
assert(norm(openloop.cost-Jgood)<1e-6);

end
