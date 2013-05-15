function test_polyhedron_projection_04_fail
%
% wrong method
%

P = ExamplePoly.randHrep('d',7);

R=P.projection([4;1],'banana');

end