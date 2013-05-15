function test_polyhedron_triangulate_04_fail
%
% low-dim polyhedron
%

P = 10*ExamplePoly.randHrep('d',7,'ne',2);

T = triangulate(P);


end