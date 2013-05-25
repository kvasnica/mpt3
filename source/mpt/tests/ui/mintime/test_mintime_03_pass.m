function test_mintime_03_pass
% import from model

model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5;
model.x.min = -5;
model.u.max = 1;
model.u.min = -1;
model.u.penalty = QuadFunction(1);
model.x.penalty = QuadFunction(1);

model.x.with('terminalSet');
model.x.terminalSet = Polyhedron('lb', -4, 'ub', 4);
MT = MinTimeController(model);
EMT = MT.toExplicit;

assert(EMT.nr==6);
assert(numel(EMT.optimizer)==2);

EMT = EMinTimeController(model);
assert(EMT.nr==6);
assert(numel(EMT.optimizer)==2);


end
