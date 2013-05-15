function test_closedloop_toSystem_01_fail
% on-line controllers cannot be converted to systems

model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
M = MPCController(model, 1);

CL = ClosedLoop(M, model);
S = CL.toSystem;

end
