function test_mintime_evaluate_01_pass

model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5;
model.x.min = -5;
model.u.max = 1;
model.u.min = -1;
model.u.penalty = QuadFunction(1);
model.x.penalty = QuadFunction(1);

% first without a terminal set, should compute LQR
M = MPCController(model);
MT = MinTimeController(M);
EMT = MT.toExplicit;
EMT.display();
[u,feasible,openloop]=EMT.evaluate(-5);
assert(feasible);
assert(u==1);
assert(openloop.cost==4);
% no open-loop solution for mintime yet
assert(isequal(size(openloop.U), [1 1]));
assert(isequal(size(openloop.X), [1 2]));
assert(all(all(isnan(openloop.X))));
assert(isequal(size(openloop.Y), [1 1]));
assert(all(all(isnan(openloop.Y))));

[u,~,openloop]=EMT.evaluate(1);
assert(norm(u-(-0.618033988749895))<1e-10);
assert(openloop.cost==0); % already in target set

% with user-specified terminal set
M.model.x.with('terminalSet');
M.model.x.terminalSet = Polyhedron('lb', -4, 'ub', 4);
MT = MinTimeController(M);
EMT = MT.toExplicit;
[u,~,openloop]=EMT.evaluate(0);
assert(u==0);
assert(openloop.cost==1);

% test infeasibility
[u, feasible, openloop] = EMT.evaluate(100);
assert(~feasible);
assert(isnan(u));
assert(openloop.cost==Inf);
% no open-loop solution for mintime yet
assert(isnan(openloop.U));
assert(isequal(size(openloop.U), [1 1]));
assert(isequal(size(openloop.X), [1 2]));
assert(all(all(isnan(openloop.X))));
assert(isequal(size(openloop.Y), [1 1]));
assert(all(all(isnan(openloop.Y))));


end
