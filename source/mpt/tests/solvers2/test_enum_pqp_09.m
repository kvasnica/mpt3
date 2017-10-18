function test_enum_pqp_09
% must fall gracefully on infeasible problems

m = mptopt;
pqp_solver = m.pqpsolver;
c = onCleanup(@() cleanme(pqp_solver));

model = LTISystem('A', 1, 'B', 1);
% lower-dimensional state constraints
model.x.min = -10;
model.x.max = -10;
model.x.penalty = QuadFunction(1);
% lower-dimensional input constraints
model.u.min = -1;
model.u.max = -1;
model.u.penalty = QuadFunction(1);
ctrl = MPCController(model, 3);

mptopt('pqpsolver', 'rlenumpqp');
[~, msg] = run_in_caller('ectrl = ctrl.toExplicit();');
asserterrmsg(msg, 'Problem is infeasible.');

mptopt('pqpsolver', 'enumpqp');
[~, msg] = run_in_caller('ectrl = ctrl.toExplicit();');
asserterrmsg(msg, 'Problem is infeasible.');

end
