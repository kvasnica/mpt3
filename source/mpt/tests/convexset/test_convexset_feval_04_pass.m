function test_convexset_feval_04_pass
%
% two sets, two identical functions
%

P(1) = Polyhedron('lb', -1, 'ub', 1);
P(2) = Polyhedron('lb', -1, 'ub', 1);

a1 = 1; b1 = 2;
a2 = 2; b2 = 3;
P.addFunction(AffFunction(a1, b1), 'f1');
P.addFunction(AffFunction(a2, b2), 'f2');

x = 0.1;

y = P.feval(x);

assert(length(y)==2);
assert(iscell(y));
assert(isequal(y{1}{1}, a1*x+b1));
assert(isequal(y{1}{2}, a2*x+b2));
assert(isequal(y{2}{1}, a1*x+b1));
assert(isequal(y{2}{2}, a2*x+b2));

end
