function test_polyhedron_triangulate_03_pass
%
% [H-V]-rep, 3D
%

P(1) = 10*ExamplePoly.randHrep('d',3);
P(2) = 10*ExamplePoly.randVrep('d',3);

while any(~P.isBounded)
    P(1) = 10*ExamplePoly.randHrep('d',3);
    P(2) = 10*ExamplePoly.randVrep('d',3);
end

T = triangulate(P);

for i=1:2
for j=1:numel(T{i})
    if any(~P(i).contains(T{i}(j)))
        error('Must be inside P.');
    end
end

end