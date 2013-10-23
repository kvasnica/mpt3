function test_mpccontroller_deltabound_02_pass
% deltamin/deltamax bounds on states (does not require extra variables)

N = 20;
x0 = [10; 1];
L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.u.min = -5;
L.u.max = 5;
ctrl = MPCController(L, N);

%% only deltaMax
ctrl.model.x.with('deltaMax');
ctrl.model.x.deltaMax = [1; 0.2];
x0 = [-10; -1];
[~, feasible, openloop] = ctrl.evaluate(x0);
assert(feasible);
% x0 must be in openloop.X(:, 1)
assert(norm(openloop.X(:, 1)-x0)<=1e-6);
dx = diff(openloop.X, 1, 2);
assert(all(max(dx, [], 2) <= ctrl.model.x.deltaMax+1e-6));
Jgood = 1234.46947430216;
assert(abs(openloop.cost-Jgood)<=1e-6);

%% only deltaMin
ctrl.model.x.without('deltaMax');
ctrl.model.x.with('deltaMin');
ctrl.model.x.deltaMin = [-1; -0.2];
x0 = [11; 1];
[~, feasible, openloop] = ctrl.evaluate(x0);
assert(feasible);
dx = diff(openloop.X, 1, 2);
assert(all(min(dx, [], 2) >= ctrl.model.x.deltaMin-1e-6));
Jgood = 1518.34690076945;
assert(abs(openloop.cost-Jgood)<=1e-5);

%% deltaMax and deltaMin
ctrl.model.x.with('deltaMax');
ctrl.model.x.deltaMin = [-1; -0.2];
ctrl.model.x.deltaMax = [0.55; 0.3];
% infeasible due to deltaMax
[~, feasible, openloop] = ctrl.evaluate(x0);
assert(~feasible);
% relax deltaMax
ctrl.model.x.deltaMax = [0.85; 0.3];
[~, feasible, openloop] = ctrl.evaluate(x0);
assert(feasible);
dx = diff(openloop.X, 1, 2);
assert(all(max(dx, [], 2) <= ctrl.model.x.deltaMax+1e-6));
assert(all(min(dx, [], 2) >= ctrl.model.x.deltaMin-1e-6));

% another x0
x0 = [-11; 0];
ctrl.model.x.deltaMax = [0.85; 0.3];
[~, feasible, openloop] = ctrl.evaluate(x0);
assert(feasible);
dx = diff(openloop.X, 1, 2);
assert(all(max(dx, [], 2) <= ctrl.model.x.deltaMax+1e-6));
assert(all(min(dx, [], 2) >= ctrl.model.x.deltaMin-1e-6));

end
