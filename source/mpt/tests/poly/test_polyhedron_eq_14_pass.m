function test_polyhedron_eq_14_pass
%
% empty polyhedron-non-empty polyhedron
% 

P = ExamplePoly.randHrep;
Q = Polyhedron;

[worked, msg] = run_in_caller('ts = (P==Q); ');
assert(~worked);
asserterrmsg(msg,'Polyhedra must be of the same dimension.');

end
