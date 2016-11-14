function test_polyhedron_shoot_12_pass
%
% wrong dim
%
 
P = ExamplePoly.randHrep('d',2);

[worked, msg] = run_in_caller('P.shoot(randn(1,2),[1;2;3]); ');
assert(~worked);
asserterrmsg(msg,'The vector "x0" must have the length of 2.');

end