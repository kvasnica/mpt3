function test_polyhedron_distance_03_fail
%
% x is a matrix 
%

P = ExamplePoly.randHrep;
S = rand(2);

P.distance(S);

end