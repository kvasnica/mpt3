function  test_polyhedron_project_02_fail
%
% wrong-dim of x
%

P(1) = ExamplePoly.randHrep('d',4);
P(2) = ExamplePoly.randHrep('d',4,'ne',1);
d = P.project(randn(2));


end