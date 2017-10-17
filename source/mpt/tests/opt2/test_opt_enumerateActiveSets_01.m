function test_opt_enumerateActiveSets_01
% for pQPs

Double_Integrator
M = mpt_constructMatrices(sysStruct, probStruct);
pqp = Opt(M);
[a1, a2, a3, a4, n] = pqp.enumerateActiveSets();
assert(n==2785);
assert(isequal(a1{1}, 0));
assert(isequal(a1{2}, [3;4;7;8;11;12]));
assert(length(a1)==6);

[a1, a2, a3, a4, n] = pqp.enumerateActiveSets('exclude', [3 4]);
assert(n==2785);
assert(isequal(a1{1}, 0));
assert(isequal(a1{2}, [3;4;7;8;11;12]));
assert(length(a1)==6);

end
