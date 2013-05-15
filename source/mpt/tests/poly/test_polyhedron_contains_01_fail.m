function test_polyhedron_contains_01_fail
%
% too many to test
%

P = ExamplePoly.randHrep;

% infeasible
R(1) = ExamplePoly.randVrep;
R(2) = ExamplePoly.randVrep;

P.contains(R);


end