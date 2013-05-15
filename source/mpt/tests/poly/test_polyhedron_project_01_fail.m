function  test_polyhedron_project_01_fail
%
% wrong-dim
%

P(1) = ExamplePoly.randHrep;
P(2) = ExamplePoly.randHrep('d',4);
d = P.project(randn(2,4));


end