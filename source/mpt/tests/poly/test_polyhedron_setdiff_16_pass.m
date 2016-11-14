function test_polyhedron_setdiff_16_pass
%
% empty outputs
%

P = ExamplePoly.randVrep;
T = P.triangulate;

res1 = P\T;
res2 = T\P;

if numel(res1)~=1
    error('One empty polyhedron on the output.');
end

if numel(res2)~=1
    error('One empty polyhedron on the output.');
end

if ~res1.isEmptySet
    error('One empty polyhedron on the output.');
end
if ~res2.isEmptySet
    error('One empty polyhedron on the output.');
end



end