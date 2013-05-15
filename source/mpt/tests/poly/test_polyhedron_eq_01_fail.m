function test_polyhedron_eq_01_fail
%
% empty polyhedron-non-empty polyhedron
% 

P = ExamplePoly.randHrep;
Q = Polyhedron;

ts = (P==Q);

end
