function test_polyhedron_facetInteriorPoints_06_pass
%
% unbounded array
%

P(1) = Polyhedron('H',rand(8,13));
P(2) = ExamplePoly.randVrep('d',13,'nr',3);

% get all points
s = P.facetInteriorPoints;

for i=1:2
    if any(~P(i).contains(s{i}))
        error('Each point must be inside.');
    end
end

end