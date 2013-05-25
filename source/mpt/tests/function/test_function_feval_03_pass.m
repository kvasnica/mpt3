function test_function_feval_03_pass
%
% evaluation of AffFunction objects

L = randn(5, 3);
C = randn(5, 1);
x = randn(3, 1);

f = @(x) L*x + C;
g = AffFunction(L, C);
g_val = g.feval(x);
assert(isequal(f(x), g_val));

end
