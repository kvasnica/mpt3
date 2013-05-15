function test_convexset_feval_01_fail
%
% general function, wrong dimension
%

P = Polyhedron(5*randn(6,2));
P.addFunction(Function(@(x)x));
y = P.feval(100);


end