function test_polyhedron_incidenceMap_02_pass
%
% H-polyhedron
%

P = ExamplePoly.randHrep;

M = P.incidenceMap;

if ~any(M.incVH)
    error('Must be nonempty.');
end

end