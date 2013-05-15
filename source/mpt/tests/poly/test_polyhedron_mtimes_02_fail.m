function test_polyhedron_mtimes_02_fail
%
% polyhedron-array of polyhedra
%

P = ExamplePoly.randHrep('d',3,'ne',2);
S(1) = ExamplePoly.randVrep;
S(2) = ExamplePoly.randHrep;

R = P*S;

end
