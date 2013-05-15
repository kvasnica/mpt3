function test_polyhedron_contains_03_fail
%
% empty point
%

% infeasible
R = ExamplePoly.randVrep('d',3);

R.contains([]);


end