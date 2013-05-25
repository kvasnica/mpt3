function test_mpccontroller_05_pass
% test that we can modify model's parameters and the prediction horizon

L = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
L.x.max = 5;
L.x.min = -4;
L.u.max = 3;
L.u.min = -2;

% basic syntax with just the model, should set N=1
M = MPCController(L);
M.model.y.max = 8;
assert(M.model.y.max==8);

M.model.x.with('terminalPenalty');
M.model.x.terminalPenalty = OneNormFunction(1);

M.N = 4;

end
