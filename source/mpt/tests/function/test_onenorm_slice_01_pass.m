function test_onenorm_slice_01_pass
% slicing of 1/infty-norm functions

% 1-norm
fun = OneNormFunction(eye(2));
sliced = fun.slice(1, 2.4);
assert(isa(sliced, 'Function'));

x = [2.4; 3.5];
fx = fun.feval(x);
sx = sliced.feval(x(2));
assert(abs(fx-sx)<1e-10);
sx_expected = 5.9;
assert(abs(sx-sx_expected)<1e-10);

% inf-norm
fun = InfNormFunction(eye(2));
sliced = fun.slice(1, 2.4);
assert(isa(sliced, 'Function'));

x = [2.4; 3.5];
fx = fun.feval(x);
sx = sliced.feval(x(2));
assert(abs(fx-sx)<1e-10);
sx_expected = 3.5;
assert(abs(sx-sx_expected)<1e-10);

end
