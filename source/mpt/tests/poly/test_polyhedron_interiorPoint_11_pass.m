function test_polyhedron_interiorPoint_11_pass
%
% if facet is required, polyhedron must be in minimal rep
%

P = ExamplePoly.randHrep;

[worked, msg] = run_in_caller('P.interiorPoint(1); ');
assert(~worked);
asserterrmsg(msg,'Polyhedron must be in minimal representation when you want compute any interior point of its facets. Use "minHRep()" to compute the facets.');

end