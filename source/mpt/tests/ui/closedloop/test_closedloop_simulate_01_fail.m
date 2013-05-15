function test_closedloop_simulate_01_fail
% simulation requires initialization

Double_Integrator; S = sysStruct;
model = LTISystem('A', S.A, 'B', S.B, 'C', S.C, 'D', S.D);
model.u.min = S.umin;
model.u.max = S.umax;
model.x.min = S.ymin;
model.x.max = S.ymax;
model.x.penalty = Penalty(probStruct.Q, 2);
model.u.penalty = Penalty(probStruct.R, 2);
M = MPCController(model, 3);

CL = ClosedLoop(M, model);
D = CL.simulate(10);

end
