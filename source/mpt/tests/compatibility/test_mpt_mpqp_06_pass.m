function test_mpt_mpqp_06_pass
% mpt_call_mpqp must not modify the Opt object

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
params = Y.internal.parameters;

% plcp without calling mpqp first:
pqp = Opt(Y.constraints, Y.objective, params, Y.variables.u(:));
sol_plcp = mpt_call_plcp(pqp);

% calling mpqp first used to corruct the Opt object, leading to a failure
% in the subsequent call to plcp:
pqp = Opt(Y.constraints, Y.objective, params, Y.variables.u(:));
sol_mpqp = mpt_call_mpqp(pqp);
sol_plcp = mpt_call_plcp(pqp);

end
