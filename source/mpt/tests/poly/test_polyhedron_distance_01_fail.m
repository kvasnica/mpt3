function test_polyhedron_distance_01_fail
%
% two S are not allowed
%

P = ExamplePoly.randHrep;
S(1) = ExamplePoly.randHrep;
S(2) = ExamplePoly.randHrep;

P.distance(S);

end