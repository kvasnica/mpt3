function test_polyhedron_triangulate_02_pass
%
% V-rep
%

P = 10*ExamplePoly.randHrep('d',2);

while ~P.isBounded
    P = 10*ExamplePoly.randHrep('d',2);
end

T = triangulate(P);


for i=1:numel(T)
    if any(~P.contains(T(i)))
        error('Must be inside P.');
    end
end

end