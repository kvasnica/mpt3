function test_mintime_02_pass
% import from MPCController

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

assert(EMT.nr==16);
assert(numel(EMT.optimizer)==6);

% with user-specified terminal set
M.model.x.with('terminalSet');
M.model.x.terminalSet = Polyhedron('lb', -4, 'ub', 4);
MT = MinTimeController(M);
EMT = MT.toExplicit;
EMT.display();

assert(EMT.nr==6);
assert(numel(EMT.optimizer)==2);

end
