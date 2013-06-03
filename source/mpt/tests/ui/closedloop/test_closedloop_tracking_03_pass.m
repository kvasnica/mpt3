function test_closedloop_tracking_03_pass
% deltau constraints (requires to properly propagate the previous input)

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.u.min = -1; L.u.max = 1;
L.x.min = [-5; -5]; L.x.max = [5;5];
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.x.with('reference');
L.x.reference = 'free';
L.u.with('deltaMax');
L.u.with('deltaMin');
L.u.deltaMax = 0.5;
L.u.deltaMin = -0.5;
ctrl = MPCController(L, 5);

xref = [2;0];
x0 = [-5; 0];
uprev = -0.5;
Nsim = 30;
d = ctrl.simulate(x0, Nsim, 'x.reference', xref, 'u.previous', uprev);
assert(length(d.U)==Nsim);
du = diff([uprev d.U]);
assert(max(du) <= L.u.deltaMax);
assert(min(du) >= L.u.deltaMin);
Jgood = 524.894973036791;
assert(abs(sum(d.cost) - Jgood) <= 1e-8);

% must nicely complain if u.previous is not provided
[~, msg] = run_in_caller('ctrl.simulate(x0, 30, ''x.reference'', xref)');
asserterrmsg(msg, 'Please provide initial value of "u.previous".');

end
