function test_function_slice_01_pass
% tests Function/slice

fun = Function(@(x) sin(x(1))*abs(x(2))+x(3));

dims = 2; keep = [1 3];
values = 0.8;
sliced = fun.slice(dims, values);
x = [0.5; 0.5; 0.5];
x(dims)=values;
fx = fun.feval(x);
sx = sliced.feval(x(keep));
assert(abs(fx-sx)<1e-10);

dims = [3 1]; keep = 2;
values = [-0.3; 0.1];
sliced = fun.slice(dims, values);
x = [0.5; 0.5; 0.5];
x(dims)=values;
fx = fun.feval(x);
sx = sliced.feval(x(keep));
assert(abs(fx-sx)<1e-10);

end
