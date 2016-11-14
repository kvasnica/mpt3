function test_mpccontroller_tracking_03_pass
% LTI, output + input tracking

N = 20;
x0 = [1; 1];
uref = 0.5;
yref = 1;

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5], 'C', [1 0]);
L.y.penalty = QuadFunction(1);
L.u.penalty = QuadFunction(1);
L.u.min = -1;
L.u.max = 1;
L.u.with('reference');
L.u.reference = 'free';
L.y.with('reference');
L.y.reference = 'free';
ctrl = MPCController(L, N);

% bogus settings must alert the user
[~, msg] = run_in_caller('ctrl.evaluate(x0)');
asserterrmsg(msg, 'Please provide initial value of "u.reference".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''u.reference'', uref)');
asserterrmsg(msg, 'Please provide initial value of "y.reference".');

% correct settings
[u, feasible, openloop] = ctrl.evaluate(x0, 'u.reference', uref, 'y.reference', yref);
Jgood = 7.85511650857683;
ugood = -0.869123522230408;
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assertwarning(abs(u - ugood) <= 1e-8);

% swapping options must lead to the same result
[u, feasible, openloop] = ctrl.evaluate(x0, 'y.reference', yref, 'u.reference', uref);
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assertwarning(abs(u - ugood) <= 1e-8);

% the same result must be obtained by setting the references to fixed
% values
L.u.reference = uref;
L.y.reference = yref;
[u, feasible, openloop] = ctrl.evaluate(x0, 'y.reference', yref, 'u.reference', uref);
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assertwarning(abs(u - ugood) <= 1e-8);

end
