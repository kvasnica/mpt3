function test_function_feval_04_pass
%
% evaluation of NormFunction objects

Q = randn(2, 10);
x = randn(10, 1);

% 1-norm via NormFunction
n = 1;
f = @(z) norm(Q*z, n);
g = NormFunction(n, Q);
g_val = g.feval(x);
assert(isequal(f(x), g_val));

% inf-norm via NormFunction
n = Inf;
f = @(z) norm(Q*z, n);
g = NormFunction(n, Q);
g_val = g.feval(x);
assert(isequal(f(x), g_val));

% 1-norm via OneNormFunction
n = 1;
f = @(z) norm(Q*z, n);
g = OneNormFunction(Q);
g_val = g.feval(x);
assert(isequal(f(x), g_val));

% inf-norm via InfNormFunction
n = Inf;
f = @(z) norm(Q*z, n);
g = InfNormFunction(Q);
g_val = g.feval(x);
assert(isequal(f(x), g_val));

end
