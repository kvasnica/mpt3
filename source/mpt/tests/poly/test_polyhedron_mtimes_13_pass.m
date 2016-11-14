function test_polyhedron_mtimes_13_pass
%
% polyhedron-array of polyhedra
%

P = ExamplePoly.randHrep('d',3,'ne',2);
S(1) = ExamplePoly.randVrep;
S(2) = ExamplePoly.randHrep;

[worked, msg] = run_in_caller('R = P*S; ');
assert(~worked);
asserterrmsg(msg,'Only one polyhedron "S" can be provided.');

end
