function test_polyhedron_incidenceMap_01_pass
%
% empty  polyhedron
%

P = Polyhedron(randn(18,3),randn(18,1));

if ~P.isEmptySet
    error('P must be empty.');
end

M = P.incidenceMap;

if any(M.incVH)
    error('Must be all zeros because it is empty polyhedron.');
end

end