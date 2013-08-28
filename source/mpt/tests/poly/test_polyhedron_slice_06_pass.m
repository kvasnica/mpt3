function test_polyhedron_slice_06_pass
% slicing of 1/infty-norm functions over polyhedron

P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
n1 = OneNormFunction(eye(2));
ni = InfNormFunction(eye(2));
P.addFunction(n1, 'one');
P.addFunction(ni, 'inf');

value = 0.5;
S = P.slice(1, 0.5);

x2 = 0.1;
x = [value; x2];
fx = P.feval(x, 'one');
sx = S.feval(x2, 'one');
assert(abs(fx-sx)<1e-10);

fx = P.feval(x, 'inf');
sx = S.feval(x2, 'inf');
assert(abs(fx-sx)<1e-10);

end
