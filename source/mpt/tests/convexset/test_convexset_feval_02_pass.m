function test_convexset_feval_02_pass
%
% point inside of the 2D set
%

P = Polyhedron('lb',[-4;-4],'ub',[3,3]);
a = randn(2); b = rand(2,1);

P.addFunction(AffFunction(a, b), 'f');
x = [1; 0];
y1 = P.feval(x(:)');
assert(isequal(y1, a*x+b));

y2 = P.feval(x);
assert(isequal(y2, a*x+b));


end
