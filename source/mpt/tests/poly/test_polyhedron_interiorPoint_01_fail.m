function test_polyhedron_interiorPoint_01_fail
%
% if facet is required, polyhedron must be in minimal rep
%

P = ExamplePoly.randHrep;

P.interiorPoint(1);

end