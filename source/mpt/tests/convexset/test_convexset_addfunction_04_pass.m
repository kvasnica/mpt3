function test_convexset_addfunction_04_pass
%
% teast replacing of a function
%

P = Polyhedron('lb', -1, 'ub', 1);;
f1 = @(x) x;
f2 = @(x) 2*x;
P.addFunction(f1, 'f');
g = P.getFunction('f');
x = 0.5;
assert(g.feval(x)==f1(x));
P.addFunction(f2, 'f');
g = P.getFunction('f');
assert(g.feval(x)==f2(x));

end
