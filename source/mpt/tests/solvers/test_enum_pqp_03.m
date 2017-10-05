function test_enum_pqp_03
% range of the optimizer must be correct when going via Opt/yalmip

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

clear sol
mpsol = solvemp(d.constraints, d.objective, [], d.internal.parameters, d.variables.u(:));
sol.xopt = mpt_mpsol2pu(mpsol);
for i = 1:sol.xopt.Num
    assert(sol.xopt.Set(i).Functions('primal').R==N*model.nu);
    assert(sol.xopt.Set(i).Functions('primal').D==model.nx);
end

% direct call to mpt_enum_pqp without eliminateEquations
pqp = Opt(d.constraints, d.objective, d.internal.parameters, d.variables.u(:));
sol = mpt_enum_pqp(pqp);
for i = 1:sol.xopt.Num
    assert(sol.xopt.Set(i).Functions('primal').R==N*model.nu);
    assert(sol.xopt.Set(i).Functions('primal').D==model.nx);
end

% direct call to mpt_enum_pqp with eliminateEquations
pqp = Opt(d.constraints, d.objective, d.internal.parameters, d.variables.u(:));
pqp.eliminateEquations();
sol = mpt_enum_pqp(pqp);
for i = 1:sol.xopt.Num
    assert(sol.xopt.Set(i).Functions('primal').R==N*model.nu);
    assert(sol.xopt.Set(i).Functions('primal').D==model.nx);
end

% now via Opt/solve - does not require manual elimination of equalities
pqp = Opt(d.constraints, d.objective, d.internal.parameters, d.variables.u(:));
sol = pqp.solve();
for i = 1:sol.xopt.Num
    assert(sol.xopt.Set(i).Functions('primal').R==N*model.nu);
    assert(sol.xopt.Set(i).Functions('primal').D==model.nx);
end

end
