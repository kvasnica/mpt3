function test_polyhedron_distance_10_pass
%
% x is a matrix 
%

P = ExamplePoly.randHrep;
S = rand(2);

[worked, msg] = run_in_caller('P.distance(S); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real vector.');

end