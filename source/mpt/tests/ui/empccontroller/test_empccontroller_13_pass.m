function test_empccontroller_13_pass
% empc with the regionless format

% remember the original solver and set it back when the function ends
m = mptopt;
pqp_solver = m.pqpsolver;
c = onCleanup(@() mptopt('pqpsolver', pqp_solver));
mptopt('pqpsolver', 'enumpqp');

Double_Integrator;
ctrl = mpt_control(sysStruct, probStruct);
assert(ctrl.optimizer.Num==25);
assert(isa(ctrl.optimizer.Set(1), 'Polyhedron'));
d = ctrl.simulate([4; 0], 10);
assert(size(d.U, 2)==10); % must be feasible over 10 steps
Uexp = [-1 -1 0.16033 0.5214 0.48344 0.34755 0.22052 0.1289 0.070647 0.036552];
assert(norm(d.U-Uexp)<1e-4);

end
