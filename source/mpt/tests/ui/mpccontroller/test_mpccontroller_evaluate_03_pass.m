function test_mpccontroller_evaluate_03_pass
% tests MPCController/evaluate (nx=3, nu=2)

ThirdOrder
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N);
x0 = [1; 1; 1];
[u, ~, openloop] = M.evaluate(x0);
Ugood = [-0.9409157644 -0.4837086178 -0.2798426207 -0.16636795 -0.0992959492;0.3188796724 -0.0157796996 0.0078671325 0.0045762165 0.0028065468];
Xgood = [1 0.505908423561224 0.303286225120538 0.180793303750929 0.107978914060792 0.0644955543950193;1 0.0247880958697152 0.0352279176798963 0.0193960356802311 0.011600905336061 0.00692264698977828;1 0.105908423561224 -0.0353012098422534 -0.0279915912816937 -0.0174963505569816 -0.0105191394360211];
Ygood = [1 0.505908423561224 0.303286225120538 0.180793303750929 0.107978914060792;1 0.0247880958697152 0.0352279176798963 0.0193960356802311 0.011600905336061;1 0.105908423561224 -0.0353012098422534 -0.0279915912816937 -0.0174963505569816];
Jgood = 3.54916814685845;
assert(norm(openloop.cost-Jgood)<1e-7);
assert(norm(u-Ugood(:, 1))<1e-7);
assert(norm(openloop.U-Ugood)<1e-7);
assert(norm(openloop.X-Xgood)<1e-7);
assert(norm(openloop.Y-Ygood)<1e-7);


% infeasible problem
[u, feasible, openloop] = M.evaluate(100*ones(3, 1));
assert(~feasible);
assert(all(isnan(u)));
assert(isequal(size(u), [2 1]));
assert(openloop.cost==Inf);
assert(all(all(isnan(openloop.X))));
assert(all(all(isnan(openloop.U))));
assert(all(all(isnan(openloop.Y))));
assert(isequal(size(openloop.X), [3 probStruct.N+1]));
assert(isequal(size(openloop.U), [2 probStruct.N]));
assert(isequal(size(openloop.Y), [3 probStruct.N]));

end
