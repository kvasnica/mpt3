function test_polyhedron_incidenceMap_05_pass
%
% He-polyhedron, V-R array
%

P(1) = ExamplePoly.randHrep('d',5,'ne',2);
P(2) = ExamplePoly.randHrep('d',16,'ne',9);

M = P.incidenceMap;

if ~any(M(1).incVH)
    error('Must be nonempty.');
end
if ~any(M(2).incVH)
    error('Must be nonempty.');
end

end
