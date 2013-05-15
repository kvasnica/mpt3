function test_convexset_addfunction_04_pass
%
% teast replacing of a function
%

P = Polyhedron;
f1 = @(x) x;
f2 = @(x) 2*x;
P.addFunction(f1, 'f');
g = P.getFunction('f');
assert(g(1)==1);
P.addFunction(f2, 'f');
g = P.getFunction('f');
assert(g(1)==2);

end
