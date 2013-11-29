function test_opt_feasibleset_04_pass
% feasible set of a pLCP

Double_Integrator;
M = mpt_constructMatrices(sysStruct, probStruct);
prob = Opt(M);
Kpqp = prob.feasibleSet(); % uses the pQP formulation

plcp = prob.qp2lcp();
% define the plcp from scratch to make sure the pQP constraints are not
% stored in the object
opt.Ath = plcp.Ath;
opt.bth = plcp.bth;
opt.M = plcp.M;
opt.q = plcp.q;
opt.Q = plcp.Q;
plcp = Opt(opt);
Kplcp = plcp.feasibleSet();
assert(Kpqp==Kplcp);


end
