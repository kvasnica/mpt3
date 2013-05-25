function test_mpccontroller_soft_02_pass
% tests optimization with softMin constraints

% soft constraints added to the controller's prediction model directly (not
% influenced by system.copy):
sys = LTISystem('A', 0.9, 'B', 1, 'C', 1);
sys.x.penalty = QuadFunction(1);
sys.u.penalty = QuadFunction(1);
sys.x.min = -1; sys.x.max = 1;
sys.u.min = -1; sys.u.max = 1;
M = MPCController(sys, 4);
M.model.x.with('softMin');
M.model.x.softMin.maximalViolation = 3;
x0 = -3.5;
[u, feasible, openloop] = M.evaluate(x0);
Ugood = -[-1 -1 -0.420750000027869 -2.05202736124714e-11];
assert(feasible);
assert(norm(u-Ugood(:, 1))<1e-7)
assert(norm(openloop.U-Ugood)<1e-4); % higher tolerance due to gurobi

% soft constraints added to system (affected by sys.copy):
sys = LTISystem('A', 0.9, 'B', 1, 'C', 1);
sys.x.penalty = QuadFunction(1);
sys.u.penalty = QuadFunction(1);
sys.x.min = -1; sys.x.max = 1;
sys.u.min = -1; sys.u.max = 1;
sys.x.with('softMin');
sys.x.softMin.maximalViolation = 3;
M = MPCController(sys, 4);
x0 = -3.5;
[~, ~, openloop] = M.evaluate(x0);
Ugood = -[-1 -1 -0.420750000027869 -2.05202736124714e-11];
assert(norm(openloop.U-Ugood)<1e-4);

% should be infeasible if we go beyond maximalViolation
x0 = -10;
[u, feasible, openloop] = M.evaluate(x0);
assert(isequal(size(openloop.U), [1 4]));
assert(all(isnan(u)));
assert(isequal(openloop.cost, Inf));


end
