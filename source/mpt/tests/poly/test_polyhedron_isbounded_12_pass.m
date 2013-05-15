function test_polyhedron_isbounded_12_pass
%
% bounded polytope
%

load data_isbounded1

if ~Rn.isBounded
    error('This polyhedron is bounded.');
end


end