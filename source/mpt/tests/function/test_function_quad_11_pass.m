function test_function_quad_11_pass
% test the "weight" getter

A = randn(2); b = randn(1, 2);
F = QuadFunction(A, b);
W = F.weight;
assert(isequal(W, A));

end
