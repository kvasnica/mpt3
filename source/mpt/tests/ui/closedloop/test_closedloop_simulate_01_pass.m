function test_closedloop_simulate_01_pass

Double_Integrator; S = sysStruct;
model = LTISystem('A', S.A, 'B', S.B, 'C', S.C, 'D', S.D);
model.u.min = S.umin;
model.u.max = S.umax;
model.x.min = S.ymin;
model.x.max = S.ymax;
model.x.penalty = OneNormFunction(probStruct.Q);
model.u.penalty = OneNormFunction(probStruct.R);
M = MPCController(model, 3);

CL = ClosedLoop(M, model);
D = CL.simulate([4; 0], 10);
Xgood = [4 3 1.5 0.5 0 0 0 0 0 0 0;0 -0.5 -1 -1 -0.75 -0.375 -0.1875 -0.09375 -0.046875 -0.0234375 -0.01171875];
Ugood = [-1 -1 -2.46519032881566e-32 0.5 0.75 0.375 0.1875 0.09375 0.046875 0.0234375];
Ygood = [4 3 1.5 0.5 0 0 0 0 0 0;0 -0.5 -1 -1 -0.75 -0.375 -0.1875 -0.09375 -0.046875 -0.0234375];
Jgood = [11.5 8.5 5.25 3.875 2.4375 1.21875 0.609375 0.3046875 0.15234375 0.076171875];

assert(norm(D.X-Xgood)<1e-10);
assert(norm(D.U-Ugood)<1e-10);
assert(norm(D.Y-Ygood)<1e-10);
assert(norm(D.cost-Jgood)<1e-10);

% double-check cost
for i = 1:size(Ugood, 2)
	[u, ~, openloop] = M.evaluate(Xgood(:, i));
	assert(norm(Ugood(:, i)-u)<1e-10);
	assert(norm(openloop.cost-Jgood(i))<1e-10);
end

end
