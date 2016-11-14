function test_polyhedron_intersect_08_pass
%
% wrong dim in H-H polyhedra
%

P = Polyhedron('lb',[0;0;0]);
S = ExamplePoly.randHrep;

[worked, msg] = run_in_caller('R = P.intersect(S); ');
assert(~worked);
asserterrmsg(msg,'Dimension of S must be the same as P (3).');


end