function test_polyhedron_homogenize_09_pass
%
% wrong type
%

P = ExamplePoly.randVrep;

[worked, msg] = run_in_caller('R = P.homogenize(''hrepp''); ');
assert(~worked);
asserterrmsg(msg,'Unknown type hrepp');

end