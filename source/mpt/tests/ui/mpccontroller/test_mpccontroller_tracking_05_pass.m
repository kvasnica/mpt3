function test_mpccontroller_tracking_05_pass
% LTI, state tracking with delta_u penalization

N = 20;
x0 = [1; 1];
xref = [2; 0];
uprev = 0;
L = LTISystem('A', [1 1; 0.1 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(eye(2));
L.u.min = -5;
L.u.max = 5;
L.x.with('reference');
L.x.reference = 'free';

%% first without deltau penalties, must get the same result as in MPT2
L.u.penalty = QuadFunction(1);
ctrl = MPCController(L, N);
[u, feasible, openloop] = ctrl.evaluate(x0, 'x.reference', xref, 'u.previousValue', uprev);
Jgood = 10.0469828264527; % value from MPT2
assert(abs(openloop.cost-Jgood) <= 1e-8);

%% now with deltau penalties
L.u.penalty = [];
L.u.with('deltaPenalty');
L.u.deltaPenalty = QuadFunction(1);
ctrl = MPCController(L, N);
[u, feasible, openloop] = ctrl.evaluate(x0, 'x.reference', xref, 'u.previous', uprev);
Jgood = 6.74386652254278; % from MPT2
assert(abs(openloop.cost-Jgood) <= 1e-8);

%% test wrong options
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''x.reference'', x0)');
asserterrmsg(msg, 'Please provide initial value of "u.previous".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''u.previous'', 0)');
asserterrmsg(msg, 'Please provide initial value of "x.reference".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''u.previous'', 0, ''x.reference'', [1; 2; 3])');
asserterrmsg(msg, '"x.reference" must be a 2x1 vector.');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''u.previous'', [0; -1], ''x.reference'', [1; 2])');
asserterrmsg(msg, '"u.previous" must be a 1x1 vector.');

%% previous value out of bounds
uprev = 2*L.u.max;
[u, feasible, openloop] = ctrl.evaluate(x0, 'x.reference', xref, 'u.previous', uprev);
assert(~feasible);

end
