function test_mpccontroller_evaluate_04_pass
% tests MPCController/evaluate (ny=0)

ThirdOrder
sysStruct.C = zeros(0, 3); sysStruct.D = zeros(0, 2);
sysStruct.xmin = sysStruct.ymin;
sysStruct.xmax = sysStruct.ymax;
sysStruct = rmfield(sysStruct, 'ymin');
sysStruct = rmfield(sysStruct, 'ymax');
model = mpt_import(sysStruct, probStruct);
assert(isempty(model.C));

M = MPCController(model, probStruct.N);
x0 = [1; 1; 1];
[u, ~, openloop] = M.evaluate(x0);
Ugood = [-0.9409157644 -0.4837086178 -0.2798426207 -0.16636795 -0.0992959492;0.3188796724 -0.0157796996 0.0078671325 0.0045762165 0.0028065468];
Jgood = 3.54916814685845;
assert(norm(u-Ugood(:, 1))<1e-7);
assert(norm(openloop.U-Ugood)<1e-7);
assert(norm(openloop.cost-Jgood)<1e-7);
assert(isempty(openloop.Y));
assert(isequal(size(openloop.Y), [0 probStruct.N]));

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
assert(isequal(size(openloop.Y), [0 probStruct.N]));

end
