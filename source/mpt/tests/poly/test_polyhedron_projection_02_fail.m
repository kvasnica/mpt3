function test_polyhedron_projection_02_fail
%
% wrong dim
%

P = ExamplePoly.randHrep('d',7);

R=P.projection([4;15]);

end