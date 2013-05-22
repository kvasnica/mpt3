function test_empccontroller_clicksim_01_pass

Double_Integrator
probStruct.norm = 1;
probStruct.N = 2;
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, probStruct.N);

E.clicksim('x0', [2; 1]);
E.clicksim('x0', [2; 2], 'N_sim', 10);

% for x0=[-2; 4] the 3rd step is infeasible
d = E.clicksim('x0', [-2; 4]);
assert(isequal(size(d.X), [2 3]))
assert(norm(d.X-[-2 1 3.5;4 3.5 3])<1e-12);
assert(norm(d.U-[-1 -1])<1e-12);
assert(norm(d.cost-[19 21])<1e-12);

% all feasible for x0 = [-3; 3];
d = E.clicksim('x0', [-3; 3], 'N_sim', 18);
assert(isequal(size(d.X), [2 19]));

end


