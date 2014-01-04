function test_mpccontroller_construct_02_pass
% MPCController/construct() with sdpsettings

L = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
L.x.max = 5;
L.x.min = -4;
L.u.max = 3;
L.u.min = -2;

% custom sdpsettings
M = MPCController(L, 2);
M.construct(sdpsettings('verbose', 1));

end
