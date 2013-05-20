function test_polyhedron_facetInteriorPoints_04_pass
%
% array of H-V polyhedra in different dimensions
%

P(1) = ExamplePoly.randHrep('d',6);
P(2) = ExamplePoly.randVrep('d',4);

% get all points
s = P.forEach(@(e) e.facetInteriorPoints, 'UniformOutput', false);

for i=1:2
    if any(~P(i).contains(s{i}'))
        error('Each point must be inside.');
    end
end

end
