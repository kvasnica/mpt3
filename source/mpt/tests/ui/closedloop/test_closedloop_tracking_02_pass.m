function test_closedloop_tracking_02_pass
% tracking time-varying references

%% state tracking
N = 5;
x0 = [0; 0];
% step change of x1ref at time 16 from 1 to 2
xref = [1*ones(1, 15), 2*ones(1, 15); zeros(1, 30)];
Nsim = size(xref, 2);

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.u.min = -1;
L.u.max = 1;
L.x.with('reference');
L.x.reference = 'free';
ctrl = MPCController(L, N);
loop = ClosedLoop(ctrl, L);

% correct dimension (Nsim columns)
d = loop.simulate(x0, Nsim, 'x.reference', xref);
Jgood = 5.44458759738277;
assert(abs(sum(d.cost) - Jgood) <= 1e-8);

% correct dimension (single column)
d = loop.simulate(x0, Nsim, 'x.reference', xref(:, end));
Jgood = 10.9776574436656;
assert(abs(sum(d.cost) - Jgood) <= 1e-8);

% xref must be either a vector or a matrix with Nsim columns
[~, msg] = run_in_caller('loop.simulate(x0, Nsim, ''x.reference'', [1 1; 0 0])');
asserterrmsg(msg, '"x.reference" must have either 1 or 30 columns.');
% xref must have 2 rows
[~, msg] = run_in_caller('loop.simulate(x0, Nsim, ''x.reference'', ones(3, 30))');
asserterrmsg(msg, '"x.reference" must be a 2x1 vector.');


%% state and input tracking
N = 5;
x0 = [0; 0];
% step change of x1ref at time 16 from 1 to 2
xref = [1*ones(1, 15), 2*ones(1, 15); zeros(1, 30)];
uref = [1*ones(1, 20), -0.5*ones(1, 10)];
Nsim = size(xref, 2);

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.u.min = -1;
L.u.max = 1;
L.x.with('reference');
L.x.reference = 'free';
L.u.with('reference');
L.u.reference = 'free';
ctrl = MPCController(L, N);
loop = ClosedLoop(ctrl, L);

% correct dimension (Nsim columns)
d = loop.simulate(x0, Nsim, 'u.reference', uref, 'x.reference', xref);
Jgood = 87.7787599313713;
assert(abs(sum(d.cost) - Jgood) <= 1e-8);

end
