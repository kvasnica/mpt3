function test_empccontroller_tracking_02_pass
% LTI, input tracking

N = 3;
x0 = [1; 1];
uref = 0.5;

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(1e-2*eye(2));
L.u.penalty = QuadFunction(100);
L.u.min = -1;
L.u.max = 1;
L.u.with('reference');
L.u.reference = 'free';
ctrl = EMPCController(L, N);
assert(ctrl.nr==29);

% bogus settings must alert the user
[~, msg] = run_in_caller('ctrl.evaluate(x0)');
asserterrmsg(msg, 'Please provide initial value of "u.reference".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''x.reference'', 1)');
asserterrmsg(msg, 'Please provide initial value of "u.reference".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''u.reference'', [1; 2])');
asserterrmsg(msg, '"u.reference" must be a 1x1 vector.');

% correct settings
[u, feasible, openloop] = ctrl.evaluate(x0, 'u.reference', uref);
Jgood = 0.301119997932832;
ugood = 0.498975470439407;
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8); % leave as a strict test!
assertwarning(abs(u - ugood) <= 1e-8); % leave as a strict test!

end
