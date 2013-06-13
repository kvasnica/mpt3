function test_polyhedron_shoot_13_pass
%
% wrong dim
%
 
P = ExamplePoly.randHrep('d',2);

[worked, msg] = run_in_caller('P.shoot([0;Inf]); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real vector.');

end