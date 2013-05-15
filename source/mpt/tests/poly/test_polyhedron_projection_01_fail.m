function test_polyhedron_projection_01_fail
%
% wrong dim
%

P = ExamplePoly.randHrep;

R=P.projection([0.1;2]);

end