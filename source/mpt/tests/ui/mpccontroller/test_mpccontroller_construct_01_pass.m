function test_mpccontroller_construct_01_pass
% tests MPCController/construct

L = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
L.x.max = 5;
L.x.min = -4;
L.u.max = 3;
L.u.min = -2;

% basic syntax with just the model, should set N=1
M = MPCController(L);
M.N = 4;
M.construct();

end
