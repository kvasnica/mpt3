function test_closedloop_tracking_04_pass
% delta_y constraints (requires to properly propagate the previous input)

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5], 'C', [0 1]);
L.u.min = -1; L.u.max = 1;
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.y.with('deltaMax');
L.y.with('deltaMin');
L.y.deltaMax = 0.1;
L.y.deltaMin = -0.1;
ctrl = MPCController(L, 5);

x0 = [-5; 0];
yprev = 0;
Nsim = 30;
d = ctrl.simulate(x0, Nsim, 'y.previous', yprev);
assert(length(d.U)==Nsim);
dy = diff([yprev d.Y]);
assert(max(dy) <= L.y.deltaMax);
assert(min(dy) >= L.y.deltaMin);
Jgood = 369.455218282397;
assert(abs(sum(d.cost) - Jgood) <= 1e-6);

% must nicely complain if y.previous is not provided
[~, msg] = run_in_caller('ctrl.simulate(x0, 30)');
asserterrmsg(msg, 'Please provide initial value of "y.previous".');

% now with 1-norm
L.x.penalty = OneNormFunction(eye(2));
L.u.penalty = OneNormFunction(1);
ctrl = MPCController(L, 5);
d = ctrl.simulate(x0, Nsim, 'y.previous', yprev);
assert(length(d.U)==Nsim);
dy = diff([yprev d.Y]);
assert(max(dy) <= L.y.deltaMax+1e-6);
assert(min(dy) >= L.y.deltaMin-1e-6);
Jgood = 141.519981384277;
assert(abs(sum(d.cost) - Jgood) <= 1e-6);

end
