function test_enum_pqp_01

Double_Integrator
model = mpt_import(sysStruct, probStruct);
N = 3;
ctrl = MPCController(model, N);
d = ctrl.toYALMIP();
pqp = Opt(d.constraints, d.objective, d.internal.parameters, d.variables.u(:));

options.generator = 'batch';
sol = mpt_enum_pqp(pqp, options);
assert(isequal(sol.how, 'ok'));
assert(sol.exitflag==1);
assert(sol.xopt.Num==19);

options.generator = 'iterative';
sol = mpt_enum_pqp(pqp, options);
assert(isequal(sol.how, 'ok'));
assert(sol.exitflag==1);
assert(sol.xopt.Num==19);

end
