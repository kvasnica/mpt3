function test_enum_pqp_05
% non-empty options.exclude

Double_Integrator
M = mpt_constructMatrices(sysStruct, probStruct);
pqp = Opt(M);

exclude = [3 4]; % u0max, u0min
sol = mpt_enum_pqp(pqp, struct('exclude', exclude));
assert(sol.xopt.Num==13);
assert(isequal(sol.stats.Excluded, exclude));

end
