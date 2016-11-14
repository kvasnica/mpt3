function test_closedloop_simulate_02_pass
% same as test_closedloop_simulate_01_pass, but with an explicit
% representation of the closed-loop system

Double_Integrator; S = sysStruct;
model = LTISystem('A', S.A, 'B', S.B, 'C', S.C, 'D', S.D);
model.u.min = S.umin;
model.u.max = S.umax;
model.x.min = S.ymin;
model.x.max = S.ymax;
model.x.penalty = OneNormFunction(probStruct.Q);
model.u.penalty = OneNormFunction(probStruct.R);
M = MPCController(model, 3).toExplicit;

CL = ClosedLoop(M, model);
sys = CL.toSystem();

sys.initialize([4;0]);
D = sys.simulate(zeros(0, 10));
Xgood = [4 3 1.5 0.5 0 0 0 0 0 0 0;0 -0.5 -1 -1 -0.75 -0.375 -0.1875 -0.09375 -0.046875 -0.0234375 -0.01171875];
Ygood = [4 3 1.5 0.5 0 0 0 0 0 0;0 -0.5 -1 -1 -0.75 -0.375 -0.1875 -0.09375 -0.046875 -0.0234375];

assert(norm(D.X-Xgood)<1e-10);
assert(norm(D.Y-Ygood)<1e-10);

end
