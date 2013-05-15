function test_mpccontroller_07_pass
% tests MPCController/display

m = MPCController;
T = evalc('m');
assert(~isempty(findstr(T, 'Empty MPC controller')));

L = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
m = MPCController(L);
T = evalc('m');
assert(~isempty(findstr(T, 'MPC controller (no prediction horizon defined)')));

m.N = 3;
T = evalc('m');
assert(~isempty(findstr(T, 'MPC controller (horizon: 3)')));

m = MPCController(L, 4);
T = evalc('m');
assert(~isempty(findstr(T, 'MPC controller (horizon: 4)')));

end
