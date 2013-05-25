function test_function_norm_02_pass
%
% test correct syntax and behavior

n_type = 1;
f = NormFunction(n_type);
s = evalc('f.display()');
assert(isequal(deblank(s), '1-norm function'));
assert(isa(f, 'NormFunction'));
assert(f.D==0); % unrestricted domain by default
assert(f.weight==1);
assert(isequal(f.type, n_type));

% check evaluation
x = randn(4, 1);
assert(f.feval(x)==norm(f.weight*x, n_type));

% constructor with the weight
n_Q = randn(4);
f = NormFunction(n_type, n_Q);
assert(f.feval(x)==norm(n_Q*x, n_type));

% check evaluation with updated norm type
n_type = Inf;
f = NormFunction(n_type);
s = evalc('f.display()');
assert(isequal(deblank(s), 'Inf-norm function'));
assert(f.feval(x)==norm(f.weight*x, n_type));

% check evaluation with updated weighting matrix
n_Q = randn(10);
x = randn(10, 1);
f = NormFunction(n_type, n_Q);
s = evalc('f.display()');
assert(isequal(deblank(s), 'Inf-norm function in R^10'));
assert(f.feval(x)==norm(n_Q*x, n_type));
assert(f.D==size(n_Q, 2));

% check non-square weights
x = randn(8, 1);
n_Q = randn(3, 8);
f = NormFunction(n_type, n_Q);
s = evalc('f.display()');
assert(isequal(deblank(s), 'Inf-norm function in R^8'));
assert(f.feval(x)==norm(n_Q*x, n_type));
assert(f.D==size(n_Q, 2));

% empty weifht = unrestricted domain
f = NormFunction(n_type, []);
s = evalc('f.display()');
assert(isequal(deblank(s), 'Inf-norm function'));
assert(f.D==0);

% switch to 1-norm
f = NormFunction(1);
s = evalc('f.display()');
assert(isequal(deblank(s), '1-norm function'));
assert(f.type==1);

end
