function test_function_infnorm_02_pass
%
% test correct syntax and behavior

n_type = Inf;

% constructor with the weight
n_Q = randn(3, 4);
f = InfNormFunction(n_Q);
s = evalc('f.display()');
assert(isequal(deblank(s), 'Inf-norm function in R^4'));
assert(isa(f, 'NormFunction'));
assert(isa(f, 'InfNormFunction'));
assert(f.D==size(n_Q, 2));
assert(isequal(f.Q, n_Q));
assert(isequal(f.type, n_type));

% check evaluation
x = randn(4, 1);
assert(f.feval(x)==norm(f.Q*x, n_type));

% check evaluation with updated weighting matrix
n_Q = randn(10);
x = randn(10, 1);
f = InfNormFunction(n_Q);
s = evalc('f.display()');
assert(isequal(deblank(s), 'Inf-norm function in R^10'));
assert(f.feval(x)==norm(n_Q*x, n_type));
assert(f.D==size(n_Q, 2));

% check non-square weights
x = randn(8, 1);
n_Q = randn(3, 8);
f = InfNormFunction(n_Q);
s = evalc('f.display()');
assert(isequal(deblank(s), 'Inf-norm function in R^8'));
assert(f.feval(x)==norm(n_Q*x, n_type));
assert(f.D==size(n_Q, 2));

% empty weifht = unrestricted domain
f = InfNormFunction([]);
s = evalc('f.display()');
assert(isequal(deblank(s), 'Inf-norm function'));
assert(f.D==0);

end
