function test_polyhedron_contains_30_pass
%
% dimension mismatch
%


P = ExamplePoly.randVrep('d',3);

R = ExamplePoly.randHrep;

[worked, msg] = run_in_caller('P.contains(R); ');
assert(~worked);
asserterrmsg(msg,'Polyhedron S must be of the dimension 3.');


end