function test_mpccontroller_soft_04_pass
% soft-u constraints + delta-u constraints

Double_Integrator
model = mpt_import(sysStruct, probStruct);
model.u.with('deltaMin');
model.u.deltaMin = -0.5;
model.u.with('softMin');

% u.softMin must NOT be added to the vector of parameters
ctrl = MPCController(model, 5);
Y = ctrl.toYALMIP();
assert(Y.internal.xinitFormat.n_xinit==3);

% softMin constraint not active, not needed
x0 = [2; 0];
[u, feas, openloop] = ctrl.evaluate(x0, 'u.previous', 0);
u_expected = -0.5;
J_expected = 8.3113220568559;
assert(abs(u - u_expected) < 1e-6);
assert(abs(openloop.cost - J_expected) < 1e-6);

% softMin constraint not active, needed
ctrl.model.u.min = -0.3;
[u, feas, openloop] = ctrl.evaluate(x0, 'u.previous', 0);
u_expected = -0.3;
J_expected = 10.0003143527514;
assert(abs(u - u_expected) < 1e-6);
assert(abs(openloop.cost - J_expected) < 1e-6);

% softMin constraint active, needed
ctrl.model.u.softMin.penalty = AffFunction(0, 0.1);
[u, feas, openloop] = ctrl.evaluate(x0, 'u.previous', 0);
u_expected = -0.5;
J_expected = 8.81132205679835;
assert(abs(u - u_expected) < 1e-6);
assert(abs(openloop.cost - J_expected) < 1e-6);

end
