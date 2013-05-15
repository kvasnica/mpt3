function test_polyhedron_intersect_01_fail
%
% wrong dim in H-H polyhedra
%

P = Polyhedron('lb',[0;0;0]);
S = ExamplePoly.randHrep;

R = P.intersect(S);


end