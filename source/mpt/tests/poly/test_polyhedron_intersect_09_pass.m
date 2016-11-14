function test_polyhedron_intersect_09_pass
%
% two S polyhedra
%

P = ExamplePoly.randHrep;

S(1) = Polyhedron;
S(2) = ExamplePoly.randHrep;

[worked, msg] = run_in_caller('R = P.intersect(S); ');
assert(~worked);
asserterrmsg(msg,'Only one polyhedron S is allowed.');


end