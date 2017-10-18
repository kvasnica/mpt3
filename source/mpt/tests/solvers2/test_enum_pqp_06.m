function test_enum_pqp_06
% ctrl.feedback.fplot, ctrl.partition.plot and ctrl.simulate must work even in RLENUMPQP

m = mptopt;
pqp_solver = m.pqpsolver;
c = onCleanup(@() mptopt('pqpsolver', pqp_solver));
mptopt('pqpsolver', 'rlenumpqp');

Double_Integrator
probStruct.N = 1;
ctrl = mpt_control(sysStruct, probStruct);
assert(ctrl.optimizer.Num == 9);
x0 = [3; 0]; N_sim = 10;
ctrl.feedback.fplot('primal'); close
ctrl.partition.plot; close
ctrl.clicksim('x0', x0, 'N_sim', N_sim); close
d = ctrl.simulate(x0, N_sim);
Uexp = [-1 -0.569529246893683 0.254029519068157 0.410492736054536 0.34608274876162 0.23874381466247 0.147702793935064 0.0847240281205725 0.0456928514610871 0.0232742830348092];
assert(numel(d.U)==10);
assert(norm(d.U-Uexp, Inf)<1e-4);

end
