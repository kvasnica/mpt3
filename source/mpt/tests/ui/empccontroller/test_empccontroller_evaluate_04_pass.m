function test_empccontroller_evaluate_04_pass
% tests EMPCController/evaluate (LTI, nx=3, nu=2)

ThirdOrder
model = mpt_import(sysStruct, probStruct);
M = MPCController(model, probStruct.N).toExplicit();

assert(M.nr==3);

x0 = [1; 1; 1];
[u, ~, openloop] = M.evaluate(x0);
Ugood = [-0.9409157644 -0.4837086178 -0.2798426207 -0.16636795 -0.0992959492;0.3188796724 -0.0157796996 0.0078671325 0.0045762165 0.0028065468];
Jgood = 3.54916814685845;
assert(norm(openloop.cost-Jgood)<1e-7);
assert(norm(u-Ugood(:, 1))<1e-7);
assert(norm(openloop.U-Ugood)<1e-7);
assert(isequal(size(openloop.U), [model.nu probStruct.N]));
assert(all(all(isnan(openloop.X)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.X), [model.nx probStruct.N+1]));
assert(all(all(isnan(openloop.Y)))); % keep in sync with EMPCController/evaluate
assert(isequal(size(openloop.Y), [model.ny probStruct.N]));
end
