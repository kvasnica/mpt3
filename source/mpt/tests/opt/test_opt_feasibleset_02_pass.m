function test_opt_feasibleset_02_pass
% feasible set of a pLP

% expected result
Hexp = [0.561936030282709 0 2.80968015141354;0.447283842751299 0.447283842751299 2.68370305650779;0.394100537749732 0.788201075499463 2.95575403312299;0 0.561936030282709 2.80968015141354;-0.447213595499958 0 2.23606797749979;0 -0.447213595499958 2.23606797749979;-0.355968303767977 -0.355968303767977 2.13580982260786;-0.274888628440742 -0.549777256881485 2.06166471330557];
Kexp = Polyhedron('H', Hexp);

%% LP without equalities
Double_Integrator;
probStruct.norm = Inf;
probStruct.N = 2;
M = mpt_constructMatrices(sysStruct, probStruct);
prob = Opt(M);
sol = prob.solve();

% use projection
K = prob.feasibleSet();
assert(K==Kexp);

% use regions
K = prob.feasibleSet(sol.xopt.Set);
assert(K==Kexp);

%% the same LP but with equalities
model = mpt_import(sysStruct, probStruct);
mpc = MPCController(model, probStruct.N);
Y = mpc.toYALMIP();
prob = Opt(Y.constraints, Y.objective, Y.internal.parameters, Y.variables.u(:));
assert(prob.me>0);
sol = prob.solve();
Kexp = sol.xopt.Domain;

% use projection
K = prob.feasibleSet();
assert(K==Kexp);

% use regions
K = prob.feasibleSet(sol.xopt.Set);
assert(K==Kexp);

% make sure the original problem stayed unchanged
assert(prob.me>0);

end
