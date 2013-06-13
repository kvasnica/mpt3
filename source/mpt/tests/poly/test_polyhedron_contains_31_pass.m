function test_polyhedron_contains_31_pass
%
% empty point
%

% infeasible
R = ExamplePoly.randVrep('d',3);

[worked, msg] = run_in_caller('R.contains([]); ');
assert(~worked);
asserterrmsg(msg,'The vector/matrix "x" must have 3 rows.');


end