function test_polyhedron_distance_04_fail
%
% wrong dimensions
%

P(1) = ExamplePoly.randHrep('d',3);
P(2) = ExamplePoly.randHrep('d',2);
S = ExamplePoly.randHrep('d',3);

s = P.distance(S);

end