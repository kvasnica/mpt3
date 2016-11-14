function test_plcp_26_pass
% wrong feasible set as a consequence of a wrong adjacency list

sys = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
sys.x.min = [-5; -5]; sys.x.max = [5; 5];
sys.u.min = -1; sys.u.max = 1;
sys.x.penalty = OneNormFunction(eye(2));
sys.u.penalty = QuadFunction(1);
mpc = MPCController(sys, 3);
Y = mpc.toYALMIP();
prob = Opt(Y.constraints, Y.objective, Y.internal.parameters, Y.variables.u(:));
sol = prob.solve();
% check the feasible set
K = prob.feasibleSet;
assert(sol.xopt.Domain==K);

end
