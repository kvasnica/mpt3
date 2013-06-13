function test_polyhedron_project_08_pass
%
% wrong-dim
%

P(1) = ExamplePoly.randHrep;
P(2) = ExamplePoly.randHrep('d',4);
[worked, msg] = run_in_caller('d = P.project(randn(2,4)); ');
assert(~worked);
asserterrmsg(msg,'The polyhedron array must be in the same dimension.');


end