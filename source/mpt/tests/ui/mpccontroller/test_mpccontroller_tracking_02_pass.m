function test_mpccontroller_tracking_02_pass
% LTI, input tracking

N = 20;
x0 = [1; 1];
uref = 0.5;

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(1e-2*eye(2));
L.u.penalty = QuadFunction(100);
L.u.min = -1;
L.u.max = 1;
L.u.with('reference');
L.u.reference = 'free';
ctrl = MPCController(L, N);

% bogus settings must alert the user
[~, msg] = run_in_caller('ctrl.evaluate(x0)');
asserterrmsg(msg, 'Please provide initial value of "u.reference".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''x.reference'', 1)');
asserterrmsg(msg, 'Please provide initial value of "u.reference".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''u.reference'', [1; 2])');
asserterrmsg(msg, '"u.reference" must be a 1x1 vector.');

% correct settings
[u, feasible, openloop] = ctrl.evaluate(x0, 'u.reference', uref);
Jgood = 195.915561546513;
ugood = 0.186037667506576;
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assertwarning(abs(u - ugood) <= 1e-8);

% changing the reference must work
uref = -1;
[u, feasible, openloop] = ctrl.evaluate(x0, 'u.reference', uref);
Jgood = 218.418966173325;
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8);

% updating constraints must take effect
ctrl.model.u.min = -0.6;
[u, feasible, openloop] = ctrl.evaluate(x0, 'u.reference', uref);
ugood = -0.6;
Jgood = 390.66960020478;
Ugood = repmat(ugood, 1, 20);
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assert(abs(u-ugood) <= 1e-8);
assert(norm(openloop.U-Ugood) <= 1e-8);

end
