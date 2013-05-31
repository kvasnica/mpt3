function test_empccontroller_tracking_03_pass
% LTI, output + input tracking

N = 2;
x0 = [1; 1];
uref = 0.5;
yref = 1;

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5], 'C', [1 0]);
L.x.with('terminalPenalty');
L.x.terminalPenalty = QuadFunction(1e-2*eye(2));
L.y.penalty = QuadFunction(1);
L.u.penalty = QuadFunction(1);
L.u.min = -1;
L.u.max = 1;
L.u.with('reference');
L.u.reference = 'free';
L.y.with('reference');
L.y.reference = 'free';

% on-line MPC
online = MPCController(L, N);
[u_on, feasible, openloop_on] = online.evaluate(x0, 'u.reference', uref, 'y.reference', yref);
Jgood = 1.23264105902116;
ugood = -0.27561501340568;
assert(feasible);
assert(abs(openloop_on.cost - Jgood) <= 1e-8);
assert(abs(u_on - ugood) <= 1e-8); 

% explicit MPC
explicit = online.toExplicit();
assert(explicit.nr==31); % N=3: 83

% bogus settings must alert the user
[~, msg] = run_in_caller('explicit.evaluate(x0)');
asserterrmsg(msg, 'Please provide initial value of "u.reference".');
[~, msg] = run_in_caller('explicit.evaluate(x0, ''u.reference'', uref)');
asserterrmsg(msg, 'Please provide initial value of "y.reference".');

% correct settings
[u, feasible, openloop] = explicit.evaluate(x0, 'u.reference', uref, 'y.reference', yref);
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8); % leave as a strict test!
assert(abs(u - ugood) <= 1e-8); % leave as a strict test!

% swapping options must lead to the same result
[u, feasible, openloop] = explicit.evaluate(x0, 'y.reference', yref, 'u.reference', uref);
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assert(abs(u - ugood) <= 1e-8);

end
