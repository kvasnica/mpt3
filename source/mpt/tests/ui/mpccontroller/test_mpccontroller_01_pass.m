function test_mpccontroller_01_pass
% tests empty constructor

M = MPCController;
M.display();
assert(isempty(M.model));
assert(isempty(M.N));

end
