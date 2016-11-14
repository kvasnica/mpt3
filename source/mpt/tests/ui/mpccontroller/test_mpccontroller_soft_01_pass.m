function test_mpccontroller_soft_01_pass
% tests optimization with softMax constraints

% soft constraints added to the controller's prediction model directly (not
% influenced by system.copy):
sys = LTISystem('A', 0.9, 'B', 1, 'C', 1);
sys.x.penalty = QuadFunction(1);
sys.u.penalty = QuadFunction(1);
sys.x.min = -1; sys.x.max = 1;
sys.u.min = -1; sys.u.max = 1;
M = MPCController(sys, 4);
M.model.x.with('softMax');
M.model.x.softMax.maximalViolation = 3;
x0 = 3.5;
[~, ~, openloop] = M.evaluate(x0);
Ugood = [-1 -1 -0.420750000027869 -2.05202736124714e-11];
assert(norm(openloop.U-Ugood)<1e-4); % higher tolerance due to gurobi

% soft constraints added to system (affected by sys.copy):
sys = LTISystem('A', 0.9, 'B', 1, 'C', 1);
sys.x.penalty = QuadFunction(1);
sys.u.penalty = QuadFunction(1);
sys.x.min = -1; sys.x.max = 1;
sys.u.min = -1; sys.u.max = 1;
sys.x.with('softMax');
sys.x.softMax.maximalViolation = 3;
M = MPCController(sys, 4);
x0 = 3.5;
[~, feasible, openloop] = M.evaluate(x0);
Ugood = [-1 -1 -0.420750000027869 -2.05202736124714e-11];
assert(feasible);
assert(norm(openloop.U-Ugood)<1e-4);

% should be infeasible if we go beyond maximalViolation
x0 = 10;
[u, feasible, openloop] = M.evaluate(x0);
assert(~feasible);
assert(isequal(size(openloop.U), [1 4]));
assert(all(isnan(u)));
assert(all(isnan(openloop.U)));
assert(isequal(openloop.cost, Inf));


end
