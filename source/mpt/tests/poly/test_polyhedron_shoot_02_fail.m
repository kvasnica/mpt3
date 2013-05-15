function test_polyhedron_shoot_02_fail
%
% wrong dim
%
 
P(1) = ExamplePoly.randHrep('d',18);
P(2) = ExamplePoly.randHrep('d',2);

P.shoot(randn(1,2));

end