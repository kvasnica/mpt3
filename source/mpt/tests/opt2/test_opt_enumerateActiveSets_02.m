function test_opt_enumerateActiveSets_02
% for QPs

Double_Integrator
M = mpt_constructMatrices(sysStruct, probStruct);
x = [1; 1];
qp = Opt('H', M.H, 'f', M.Cf, 'A', M.G, 'b', M.W+M.E*x)
[a1, a2, a3, a4, n] = qp.enumerateActiveSets();
assert(isempty(a1{1}));
assert(isempty(a1{2}));
assert(isempty(a1{3}));
assert(isequal(a1{4}, [16 18 20]));
assert(isempty(a1{5}));
assert(isempty(a1{6}));

[a1, a2, a3, a4, n] = qp.enumerateActiveSets('exclude', 16);
assert(isempty(a1{1}));
assert(isempty(a1{2}));
assert(isempty(a1{3}));
assert(isempty(a1{4}));
assert(isempty(a1{5}));
assert(isempty(a1{6}));

end
