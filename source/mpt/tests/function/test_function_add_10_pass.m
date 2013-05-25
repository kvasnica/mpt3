function test_function_add_10_pass
% test the "weight" getter

A = randn(2); b = randn(2, 1);
F = AffFunction(A, b);
W = F.weight;
assert(isequal(W, A));

end
