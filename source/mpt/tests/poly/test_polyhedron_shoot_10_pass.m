function test_polyhedron_shoot_10_pass
%
% wrong dim
%
 
P = ExamplePoly.randHrep('d',18);

[worked, msg] = run_in_caller('P.shoot(randn(1,5)); ');
assert(~worked);
asserterrmsg(msg,'The ray vector "r"  must have the length of 18.');

end