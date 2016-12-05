function test_enum_pqp_04
% equalities are not allowed

% remember the original solver and set it back when the function ends
m = mptopt;
pqp_solver = m.pqpsolver;
c = onCleanup(@() mptopt('pqpsolver', pqp_solver));
mptopt('pqpsolver', 'enumpqp');

Double_Integrator
probStruct.Tconstraint = 0;
N = 3;
model = mpt_import(sysStruct, probStruct);
ctrl = MPCController(model, N);
d = ctrl.toYALMIP();
pqp = Opt(d.constraints, d.objective, d.internal.parameters, d.variables.u(:));
[~, msg] = run_in_caller('mpt_enum_pqp(pqp)');
asserterrmsg(msg, 'Equalities are not allowed');
[~, msg] = run_in_caller('pqp.solve()');
asserterrmsg(msg, 'Equalities are not allowed');

end
