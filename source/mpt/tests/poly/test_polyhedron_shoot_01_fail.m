function test_polyhedron_shoot_01_fail
%
% wrong dim
%
 
P = ExamplePoly.randHrep('d',18);

P.shoot(randn(1,5));

end