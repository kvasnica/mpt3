function test_closedloop_simulate_02_fail
% simulation requires number of steps

Double_Integrator; S = sysStruct;
model = LTISystem('A', S.A, 'B', S.B, 'C', S.C, 'D', S.D);
model.u.min = S.umin;
model.u.max = S.umax;
model.x.min = S.ymin;
model.x.max = S.ymax;
model.x.penalty = QuadFunction(probStruct.Q);
model.u.penalty = QuadFunction(probStruct.R);
M = MPCController(model, 3);

CL = ClosedLoop(M, model);
D = CL.simulate([1;1]);

end
