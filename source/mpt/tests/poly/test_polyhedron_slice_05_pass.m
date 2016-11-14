function test_polyhedron_slice_05_pass
% slicing of nonlinear functions over polyhedron

P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
fun = @(x) sin(x(1))*abs(x(2));
P.addFunction(fun, 'f');

value = 0.5;
S = P.slice(1, 0.5);

x2 = 0.1;
x = [value; x2];
fx = P.feval(x);
sx = S.feval(x2);
assert(abs(fx-sx)<1e-10);

sx_expected = 0.0479425538604203;
assert(abs(sx-sx_expected) < 1e-10);

end
