function test_polyhedron_shoot_11_pass
%
% wrong dim
%
 
P(1) = ExamplePoly.randHrep('d',18);
P(2) = ExamplePoly.randHrep('d',2);

[worked, msg] = run_in_caller('P.shoot(randn(1,2)); ');
assert(~worked);
asserterrmsg(msg,'The polyhedron array must be in the same dimension.');

end