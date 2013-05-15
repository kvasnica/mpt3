function test_polyhedron_facetInteriorPoints_03_pass
%
% empty polyhedron returns empty interior points
%

P(1) = Polyhedron;
P(2) = Polyhedron('A',randn(56,2),'b',randn(56,1));

% get all points
x = P.facetInteriorPoints;

if ~all(cellfun('isempty',x))
    error('Must return empty points.');
end

end