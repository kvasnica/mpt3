function test_polyhedron_facetInteriorPoints_01_pass
%
% many facets in H-rep
%

P = Polyhedron('H',[randn(17,5) 8*rand(17,1)])+5*rand(5,1);

% get all points
x = P.facetInteriorPoints;

if any(~P.contains(x'))
    error('Each point must be inside.');
end

end
