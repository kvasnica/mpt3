function  test_polyhedron_project_03_fail
%
% wrong value in x
%

P(1) = ExamplePoly.randHrep('d',4);
P(2) = ExamplePoly.randHrep('d',4,'ne',1);
d = P.project([1,2,Inf,Inf]);


end