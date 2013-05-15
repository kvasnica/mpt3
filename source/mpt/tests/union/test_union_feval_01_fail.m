function test_union_feval_01_fail
%
% no functions
%

P = ExamplePoly.randVrep('d',4);
T= P.triangulate;

U = Union(T);

x = P.interiorPoint.x;

y1=U.feval(x);


end