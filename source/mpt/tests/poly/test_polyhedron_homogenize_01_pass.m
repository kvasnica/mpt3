function test_polyhedron_homogenize_01_pass
%
% empty polyhedron
%

P = Polyhedron;
R = P.homogenize;

if P~=R
    error('Must be empty polyhedron.');e
end

end