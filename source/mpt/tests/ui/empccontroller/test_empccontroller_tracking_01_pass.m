function test_empccontroller_tracking_01_pass
% LTI, state tracking

N = 3;
x0 = [1; 1];
xref = [3; 0];

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.u.min = -1;
L.u.max = 1;
L.x.with('reference');
L.x.reference = 'free';
ctrl = EMPCController(L, N);
% 63 regions without x.min, x.max (implies no bounds on x.reference)
assert(ctrl.nr==63);

% 53 regions with bounding of the reference
L.x.min = [-5; -5];
L.x.max = [5; 5];
ctrl = EMPCController(L, N);
assert(ctrl.nr==53);

% bogus settings must alert the user
[~, msg] = run_in_caller('ctrl.evaluate(x0)');
asserterrmsg(msg, 'Please provide initial value of "x.reference".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''u.reference'', 1)');
asserterrmsg(msg, 'Please provide initial value of "x.reference".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''x.reference'', [1; 2; 3])');
asserterrmsg(msg, '"x.reference" must be a 2x1 vector.');

% correct use
[u, feasible, openloop] = ctrl.evaluate(x0, 'x.reference', xref);
Jgood = 7.84426229508197;
ugood = 0.114754094846354;
assert(feasible);
assert(abs(openloop.cost - Jgood) <= 1e-8);
assertwarning(abs(u - ugood) <= 1e-8);

end
