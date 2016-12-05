function test_empccontroller_14_pass
% empc with the regionless format

% remember the original solver and set it back when the function ends
m = mptopt;
pqp_solver = m.pqpsolver;
c = onCleanup(@() mptopt('pqpsolver', pqp_solver));
mptopt('pqpsolver', 'rlenumpqp');

Double_Integrator;
ctrl = mpt_control(sysStruct, probStruct);
assert(ctrl.optimizer.Num==25);
assert(isa(ctrl.optimizer.Set(1), 'IPDPolyhedron'));
d = ctrl.simulate([4; 0], 10);
Uexp = [-1 -1 0.16033 0.5214 0.48344 0.34755 0.22052 0.1289 0.070647 0.036552];
assert(norm(d.U-Uexp)<1e-4);

end
