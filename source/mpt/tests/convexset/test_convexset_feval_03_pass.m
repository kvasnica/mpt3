function test_convexset_feval_03_pass
%
% polyhedron array
%

P(1) = Polyhedron('lb',[-4;-4],'ub',[3,3]);
P(2) = Polyhedron(randn(9,2),6*rand(9,1));

a = rand(7, 2); b=randn(7,1);
P.addFunction(AffFunction(a, b), 'f');

xc = P(2).chebyCenter;
y = P.feval(xc.x);

assert(length(y)==2);
assert(iscell(y));
assert(isequal(y{1}, a*xc.x+b));
assert(isequal(y{2}, a*xc.x+b));


end
