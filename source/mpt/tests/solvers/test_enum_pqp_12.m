function test_enum_pqp_12
% pQP with bounds on parameters

m = mptopt;
pqp_solver = m.pqpsolver;
c = onCleanup(@() mptopt('pqpsolver', pqp_solver));

Double_Integrator
probStruct.N=2;
M = mpt_constructMatrices(sysStruct, probStruct);
M.bndb = [1; 1; 1; 1];
pqp = Opt(M);

mptopt('pqpsolver', 'rlenumpqp');
sol1 = pqp.solve();
assert(sol1.xopt.Num==3);
assert(sol1.xopt.contains([1; 1]));
assert(~sol1.xopt.contains([3; 0]));


mptopt('pqpsolver', 'enumpqp');
sol2 = pqp.solve();
assert(sol2.xopt.Num==3);
assert(sol2.xopt.contains([1; 1]));
assert(~sol2.xopt.contains([3; 0]));

end
