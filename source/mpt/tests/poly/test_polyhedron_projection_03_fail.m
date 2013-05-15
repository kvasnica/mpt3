function test_polyhedron_projection_03_fail
%
% wrong dim
%

P = ExamplePoly.randHrep('d',7);

R=P.projection([4;1;0;5]);

end