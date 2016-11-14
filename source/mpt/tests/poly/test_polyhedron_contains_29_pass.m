function test_polyhedron_contains_29_pass
%
% too many to test
%

P = ExamplePoly.randHrep;

% infeasible
R(1) = ExamplePoly.randVrep;
R(2) = ExamplePoly.randVrep;

[worked, msg] = run_in_caller('P.contains(R); ');
assert(~worked);
asserterrmsg(msg,'Can only test containment of a single polyhedron.');


end