function test_mintime_01_fail
% if not terminal set is provided, we compute LQR set, which requires
% penalties. if they are not given, an error should be raised

model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5;
model.x.min = -5;
model.u.max = 1;
model.u.min = -1;

M = MPCController(model);
MT = MinTimeController(M);
EMT = MT.toExplicit;


end
