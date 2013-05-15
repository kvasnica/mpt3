function test_polyhedron_shoot_04_fail
%
% wrong dim
%
 
P = ExamplePoly.randHrep('d',2);

P.shoot([0;Inf]);

end