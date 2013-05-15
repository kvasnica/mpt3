function test_polyhedron_shoot_03_fail
%
% wrong dim
%
 
P = ExamplePoly.randHrep('d',2);

P.shoot(randn(1,2),[1;2;3]);

end