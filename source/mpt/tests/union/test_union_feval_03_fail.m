function test_union_feval_03_fail
%
% functions with different names
%

P(1) = ExamplePoly.randVrep('d',2);
P(1).addFunction(AffFunction(rand(2)));
P(2) = ExamplePoly.randHrep('d',2);
P(2).addFunction(AffFunction(rand(2)),'b');

U = Union(P);

x = P(1).interiorPoint.x;

y1=U.feval(x,'b');


end