function test_polyhedron_facetInteriorPoints_05_pass
%
% low-dim
%

P = ExamplePoly.randHrep('d',13,'ne',8);

% get all points
s = P.facetInteriorPoints;

if any(~P.contains(s'))
    error('Each point must be inside.');
end


end
