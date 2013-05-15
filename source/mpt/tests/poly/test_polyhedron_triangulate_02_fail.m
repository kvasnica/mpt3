function test_polyhedron_triangulate_02_fail
%
% not bounded polyhedron
%

P = Polyhedron('V',randn(5),'R',[0 0 1 -2 0.5]);

T = triangulate(P);


end