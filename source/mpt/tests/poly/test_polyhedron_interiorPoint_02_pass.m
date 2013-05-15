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

if ~iscell(res)
    error('Output must be a struct.');
end
if numel(res)~=10
    error('10 outputs are expected.');
end



end