function test_polyhedron_contains_02_fail
%
% dimension mismatch
%


P = ExamplePoly.randVrep('d',3);

R = ExamplePoly.randHrep;

P.contains(R);


end