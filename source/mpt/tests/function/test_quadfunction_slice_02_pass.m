function test_quadfunction_slice_02_pass
% tests QuadFunction/slice()

% note that the matrix is not required to be symmetric!
H = [1 2 3; 4 5 6; 7 8 9];
F = [1 2 3];
g = 1;
fun = QuadFunction(H, F, g);

dims = [3 2];
keep = setdiff(1:size(H, 1), dims);
values = [-1 2];
new = fun.slice(dims, values);
assert(isequal(new.H, 1));
assert(isequal(new.F, 3));
assert(isequal(new.g, 3));
x = [1; 2; 1];
x(dims) = values;
fx = fun.feval(x);
nx = new.feval(x(keep));
assert(abs(fx-nx)<1e-12);

dims = 3;
keep = setdiff(1:size(H, 1), dims);
values = 1;
new = fun.slice(dims, values);
assert(isequal(new.H, [1 2; 4 5]));
assert(isequal(new.F, [11 16]));
assert(isequal(new.g, 13));
x = [1; 2; 1];
x(dims) = values;
fx = fun.feval(x);
nx = new.feval(x(keep));
assert(abs(fx-nx)<1e-12);

assert(isa(new, 'QuadFunction'));
assert(new.R==size(F, 1));
assert(new.D==numel(keep));

end
