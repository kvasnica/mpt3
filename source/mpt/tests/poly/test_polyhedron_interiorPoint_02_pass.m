function test_polyhedron_interiorPoint_02_pass
%
% array of polyhedra
%

P(10,1) = Polyhedron;
for i=1:5
    P(i) = ExamplePoly.randHrep;
end
for i=6:10
    P(i) = ExamplePoly.randVrep;
end

res = P.interiorPoint;
assert(isstruct(res));
assert(numel(res)==numel(P));
assert(isfield(res(1), 'x'));
assert(isfield(res(1), 'isStrict'));
assert(isfield(res(1), 'r'));

end
