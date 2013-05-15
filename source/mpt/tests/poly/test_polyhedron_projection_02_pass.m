function test_polyhedron_projection_02_pass
%
% 2D polyhedron on 2D
%

P = ExamplePoly.randHrep;

R=P.projection([1:2]);

if R~=P
    error('R is the same as P.');
end

Q=P.projection([2,1]);

if Q==P
    error('R is not the same as P.');
end



end