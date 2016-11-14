function test_polyunion_08_pass
%
% polyhedron array in wrong dim
%

P = [ExamplePoly.randHrep; ExamplePoly.randVrep('d',8)];

[worked, msg] = run_in_caller('U = PolyUnion(P); ');
assert(~worked);
asserterrmsg(msg,'All polyhedra must be in the same dimension.');


end