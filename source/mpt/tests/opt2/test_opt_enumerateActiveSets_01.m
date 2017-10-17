function test_opt_enumerateActiveSets_01
% for pQPs

Double_Integrator
M = mpt_constructMatrices(sysStruct, probStruct);
pqp = Opt(M);
[a1, a2, a3, a4, n] = pqp.enumerateActiveSets();
assert(n==2785);
a1_exp = [0 0 0 0 0;3 0 0 0 0;4 0 0 0 0;7 0 0 0 0;8 0 0 0 0;11 0 0 0 0;12 0 0 0 0;3 7 0 0 0;3 12 0 0 0;4 8 0 0 0;4 11 0 0 0;7 11 0 0 0;8 12 0 0 0;11 15 0 0 0;12 16 0 0 0;3 7 11 0 0;4 8 12 0 0;7 11 15 0 0;8 12 16 0 0;3 7 11 15 0;4 8 12 16 0;7 11 15 17 0;8 12 16 18 0;3 7 11 15 17;4 8 12 16 18];
assert(isequal(a1, a1_exp));
assert(isequal(size(a2), [0 5]));
assert(isequal(size(a3), [1133 5]));
assert(isequal(size(a4), [529 5]));

[a1, a2, a3, a4, n] = pqp.enumerateActiveSets('exclude', [3 4]);
assert(n==1711);
a1_exp = [0 0 0 0 0;7 0 0 0 0;8 0 0 0 0;11 0 0 0 0;12 0 0 0 0;7 11 0 0 0;8 12 0 0 0;11 15 0 0 0;12 16 0 0 0;7 11 15 0 0;8 12 16 0 0;7 11 15 17 0;8 12 16 18 0];
assert(isequal(a1, a1_exp));
assert(isequal(size(a2), [0 5]));
assert(isequal(size(a3), [717 5]));
assert(isequal(size(a4), [266 5]));

end
