function test_polyhedron_projection_03_pass
%
% wrong dim
%

P = ExamplePoly.randHrep;

R=P.projection([]);

if R~=P
    error('Must be the same polyhedron.');
end

end