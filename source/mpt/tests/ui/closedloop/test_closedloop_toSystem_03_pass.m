function test_closedloop_toSystem_03_pass
% on-line controllers cannot be converted to systems

model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
M = MPCController(model, 1);

CL = ClosedLoop(M, model);
[worked, msg] = run_in_caller('S = CL.toSystem; ');
assert(~worked);
asserterrmsg(msg,'Only explicit controllers supported.');

end
