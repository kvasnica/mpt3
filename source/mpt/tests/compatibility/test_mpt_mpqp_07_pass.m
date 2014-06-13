function test_mpt_mpqp_07_pass
% tests recovery of order of variables

N = 2;
n = 2;
r = poly(repmat(-0.1, 1, n));
n = length(r)-1;
s = c2d(ss(tf(1, r)), 1);
clear sysStruct probStruct
sysStruct.A = s.A;
sysStruct.B = s.B;
sysStruct.C = s.C;
sysStruct.D = s.D;
sysStruct.umax = 1;
sysStruct.umin = -1;
sysStruct.xmax = 10*ones(n, 1);
sysStruct.xmin = -10*ones(n, 1);
probStruct.Q = eye(size(s.A));
probStruct.P_N = probStruct.Q;
probStruct.R = 1;
probStruct.N = N;
probStruct.norm = 2;
probStruct.Tconstraint = 0;
probStruct.subopt_lev = 0;
model = mpt_import(sysStruct, probStruct);
mpc = MPCController(model, probStruct.N);
Y = mpc.toYALMIP();

% parameters in the original order
params = Y.internal.parameters;
pqp = Opt(Y.constraints, Y.objective, params, Y.variables.u(:));
sol_plcp = mpt_call_plcp(pqp);
sol_mpqp = mpt_call_mpqp(pqp);
D_expected = Polyhedron('H', [0 1 10;-1 0 10;-0.112909688044286 -0.993605254789719 10.2162989863727;-0.203954254112001 -0.978980419737605 10.8374482557353;0 -1 10;0.112909688044286 0.993605254789719 10.2162989863727;1 0 10;0.203954254112001 0.978980419737605 10.8374482557353]);
assert(sol_plcp.xopt.Domain==D_expected);
assert(sol_mpqp.xopt.Domain==D_expected);

% reversed order of parameters must give all regions rotated
params = flipud(Y.internal.parameters);
pqp = Opt(Y.constraints, Y.objective, params, Y.variables.u(:));
sol_plcp_r = mpt_call_plcp(pqp);
sol_mpqp_r = mpt_call_mpqp(pqp);
Dr_expected = Polyhedron('H', [1 0 10;0 -1 10;-0.993605254789719 -0.112909688044286 10.2162989863727;-0.978980419737605 -0.203954254112001 10.8374482557353;-1 0 10;0.993605254789719 0.112909688044286 10.2162989863727;0 1 10;0.978980419737605 0.203954254112001 10.8374482557353]);
assert(sol_plcp_r.xopt.Domain==Dr_expected);
assert(sol_mpqp_r.xopt.Domain==Dr_expected);

end
