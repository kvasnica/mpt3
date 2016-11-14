function test_polyhedron_incidenceMap_04_pass
%
% He-polyhedron
%

P = ExamplePoly.randHrep('d',5,'ne',2);

M = P.incidenceMap;

if ~any(M.incVH)
    error('Must be nonempty.');
end

end