function test_polyhedron_distance_11_pass
%
% wrong dimensions
%

P(1) = ExamplePoly.randHrep('d',3);
P(2) = ExamplePoly.randHrep('d',2);
S = ExamplePoly.randHrep('d',3);

[worked, msg] = run_in_caller('s = P.distance(S); ');
assert(~worked);
asserterrmsg(msg,'Both polyhedra have to be of the same dimension.');

end