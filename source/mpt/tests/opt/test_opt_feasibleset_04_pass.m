function test_opt_feasibleset_04_pass
% feasible set of a pLCP

Double_Integrator;
M = mpt_constructMatrices(sysStruct, probStruct);
prob = Opt(M);
Kpqp = prob.feasibleSet(); % uses the pQP formulation

plcp = prob.qp2lcp();
% here Opt/feasibleSet() exploits the original pQP constraints
Kplcp = plcp.feasibleSet();
assert(Kpqp==Kplcp);
% make sure the original problem stayed a pLCP
assert(isempty(plcp.A));
assert(~isempty(plcp.M));

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
