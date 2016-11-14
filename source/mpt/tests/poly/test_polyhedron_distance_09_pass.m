function test_polyhedron_distance_09_pass
%
% two S are not allowed
%

P = ExamplePoly.randHrep;
S(1) = ExamplePoly.randHrep;
S(2) = ExamplePoly.randHrep;

[worked, msg] = run_in_caller('P.distance(S); ');
assert(~worked);
asserterrmsg(msg,'Only single polyhedron S allowed.');

end