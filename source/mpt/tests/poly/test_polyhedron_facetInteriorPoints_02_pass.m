function test_polyhedron_facetInteriorPoints_02_pass
%
% V-rep
%

P = Polyhedron('V',randn(7,3))+4*rand(3,1);

% get all points
x = P.facetInteriorPoints;

if any(~P.contains(x'))
    error('Each point must be inside.');
end

end
