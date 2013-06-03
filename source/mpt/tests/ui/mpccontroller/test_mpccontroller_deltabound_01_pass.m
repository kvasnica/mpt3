function test_mpccontroller_deltabound_01_pass
% deltamin/deltamax bounds on inputs (requires extra variables)

N = 20;
x0 = [10; 1];
uprev = 0;
L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.u.min = -5;
L.u.max = 5;
ctrl = MPCController(L, N);

%% only deltaMax
ctrl.model.u.with('deltaMax');
ctrl.model.u.deltaMax = 0.5;
[~, feasible, openloop] = ctrl.evaluate(x0, 'u.previous', uprev);
assert(feasible);
du = diff([uprev, openloop.U]);
assert(max(du) <= ctrl.model.u.deltaMax+1e-6);
Jgood = 297.280032925402;
assert(abs(openloop.cost-Jgood)<=1e-8);

%% only deltaMin
ctrl.model.u.without('deltaMax');
ctrl.model.u.with('deltaMin');
ctrl.model.u.deltaMin = -0.5;
[~, feasible, openloop] = ctrl.evaluate(x0, 'u.previous', uprev);
assert(feasible);
du = diff([uprev, openloop.U]);
assert(min(du) >= ctrl.model.u.deltaMin-1e-6);
Jgood = 483.549843793654;
assert(abs(openloop.cost-Jgood)<=1e-8);

%% deltaMax and deltaMin
ctrl.model.u.with('deltaMax');
ctrl.model.u.deltaMin = -2;
ctrl.model.u.deltaMax = 1.3;
[~, feasible, openloop] = ctrl.evaluate(x0, 'u.previous', uprev);
assert(feasible);
du = diff([uprev, openloop.U]);
assert(min(du) >= ctrl.model.u.deltaMin-1e-6);
assert(max(du) <= ctrl.model.u.deltaMax+1e-6);
Jgood = 266.904033535472;
assert(abs(openloop.cost-Jgood)<=1e-8);

%% previous value out of bounds
[~, feasible, openloop] = ctrl.evaluate(x0, 'u.previous', L.u.max*2);
assert(~feasible);

%% wrong options
[~, msg] = run_in_caller('ctrl.evaluate(x0)');
asserterrmsg(msg, 'Please provide initial value of "u.previous".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''u.previous'', [1; 2])');
asserterrmsg(msg, '"u.previous" must be a 1x1 vector.');

end
