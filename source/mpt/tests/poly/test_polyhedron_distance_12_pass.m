function test_polyhedron_distance_12_pass
%
% not valid S argument
%

P = ExamplePoly.randHrep;
S = [true;false];

[worked, msg] = run_in_caller('P.distance(S); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real vector.');

[worked, msg] = run_in_caller('P.distance([S;Inf]); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real vector.');

end