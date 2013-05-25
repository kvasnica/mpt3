function test_mintime_evaluate_01_fail
% no on-line implementation of minimum-time

model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5;
model.x.min = -5;
model.u.max = 1;
model.u.min = -1;
model.u.penalty = QuadFunction(1);
model.x.penalty = QuadFunction(1);

M = MPCController(model);
MT = MinTimeController(M);
u = MT.evaluate(1);

end
