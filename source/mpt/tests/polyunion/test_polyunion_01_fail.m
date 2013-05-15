function test_polyunion_01_fail
%
% polyhedron array in wrong dim
%

P = [ExamplePoly.randHrep; ExamplePoly.randVrep('d',8)];

U = PolyUnion(P);


end