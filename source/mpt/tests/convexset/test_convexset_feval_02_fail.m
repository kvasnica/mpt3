function test_convexset_feval_02_fail
%
% wrong dimensions
%

P = Polyhedron(5*randn(6,5));
P.addFunction(AffFunction(rand(5),rand(5,1)));
y = P.feval([1,0,0]);


end