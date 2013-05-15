function test_polyhedron_triangulate_04_pass
%
% bounding box
%

P(1) = ExamplePoly.randHrep('d',5);
P(2) = ExamplePoly.randHrep('d',4);
P(3) = 10*ExamplePoly.randVrep('d',3);

while any(~P.isBounded)
    P(1) = ExamplePoly.randHrep('d',5);
    P(2) = ExamplePoly.randHrep('d',4);
    P(3) = 10*ExamplePoly.randVrep('d',3);
end

B = P.outerApprox;

T = triangulate(B);

for i=1:3
for j=1:numel(T{i})
    if any(~B(i).contains(T{i}(j)))
        error('Must be inside P.');
    end
end

end