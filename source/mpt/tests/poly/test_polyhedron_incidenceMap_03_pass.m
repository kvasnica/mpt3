function test_polyhedron_incidenceMap_03_pass
%
% V-polyhedron
%

P = ExamplePoly.randVrep;

M = P.incidenceMap;

if ~any(M.incVH)
    error('Must be nonempty.');
end

end