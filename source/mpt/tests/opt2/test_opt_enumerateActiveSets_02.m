function test_opt_enumerateActiveSets_02
% for QPs

Double_Integrator
M = mpt_constructMatrices(sysStruct, probStruct);
x = [1; 1];
qp = Opt('H', M.H, 'f', M.Cf, 'A', M.G, 'b', M.W+M.E*x);
[a1, a2, a3, a4, n] = qp.enumerateActiveSets();
a1_exp = [16 18 20 0 0];
assert(isequal(a1, a1_exp));
assert(isempty(a2));
assert(size(a3, 1)==232);
assert(size(a4, 1)==66);


[a1, a2, a3, a4, n] = qp.enumerateActiveSets('exclude', 16);
assert(isempty(a1));
assert(isempty(a2));
assert(isequal(a3(1, :), [3 0 0 0 0]));
assert(size(a3, 1)==148);
assert(size(a4, 1)==40);

end
