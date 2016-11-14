function test_function_feval_02_pass
%
% evaluation of QuadFunction objects

Q = randn(2);
L = randn(1, 2);
C = randn;
x = randn(2, 1);

f = @(x) x'*Q*x + L*x + C;
g = QuadFunction(Q, L, C);
g_val = g.feval(x);
assert(f(x)==g_val);

end
