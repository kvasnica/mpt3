function test_polyhedron_intersect_02_fail
%
% two S polyhedra
%

P = ExamplePoly.randHrep;

S(1) = Polyhedron;
S(2) = ExamplePoly.randHrep;

R = P.intersect(S);


end