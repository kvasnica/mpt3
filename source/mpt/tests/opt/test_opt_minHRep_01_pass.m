function test_opt_minHRep_01_pass

N = 5;
Double_Integrator
probStruct.Tconstraint = 0;
model = mpt_import(sysStruct, probStruct);
ctrl = MPCController(model, N);
d = ctrl.toYALMIP();
old = Opt(d.constraints, d.objective, d.internal.parameters, d.variables.u(:));
old.eliminateEquations();
new = copy(old);
new.minHRep();
assert(old.m==54);
assert(old.n==5);
assert(old.d==2);
assert(new.m==20);
assert(new.n==5);
assert(new.d==2);

end
