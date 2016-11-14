function test_opt_eliminateEquations_20_pass
% vartype must be correct after eliminating equalities

% inf-norm MPC with equality constraints
Double_Integrator;
probStruct.N = 2;
model = mpt_import(sysStruct, probStruct);
mpc = MPCController(model, probStruct.N);
Y = mpc.toYALMIP();
prob = Opt(Y.constraints, Y.objective, Y.internal.parameters, Y.variables.u(:));
assert(prob.me>0);
assert(length(prob.vartype)==prob.n);

% we must correctly set the "vartype"
prob_elim = prob.copy();
prob_elim.eliminateEquations();
assert(length(prob_elim.vartype)==prob_elim.n);

end
