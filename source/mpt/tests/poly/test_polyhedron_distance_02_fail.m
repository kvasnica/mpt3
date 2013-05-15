function test_polyhedron_distance_02_fail
%
% not valid S argument
%

P = ExamplePoly.randHrep;
S = [true;false];

P.distance(S);

P.distance([S;Inf]);

end