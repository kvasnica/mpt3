function test_polyhedron_triangulate_03_fail
%
% infeasible polyhedron
%

P = Polyhedron('H',randn(24,4));

T = triangulate(P);


end