function test_enum_pqp_04
% IPDPolyhedron correctness check

m = mptopt;
pqp_solver = m.pqpsolver;
c = onCleanup(@() mptopt('pqpsolver', pqp_solver));
mptopt('pqpsolver', 'rlenumpqp');

%% first via mpt_control
Double_Integrator
probStruct.N = 5;
ctrl = mpt_control(sysStruct, probStruct);
assert(ctrl.optimizer.Num == 25);

%% now via condensed matrices
Double_Integrator
probStruct.N = 5;
M = mpt_constructMatrices(sysStruct, probStruct);
prob = Opt(M);
sol = prob.solve();
assert(sol.xopt.Num==25);

%% via YALMIP



end
