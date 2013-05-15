function test_convexset_feval_01_pass
%
% x in 1D
%

P = Polyhedron('lb', -1, 'ub', 1);
a = 1;
b = 1;
P.addFunction(AffFunction(a,b), 'f');
x = -0.1;
y = P.feval(x);
assert(y==a*x+b);

end
