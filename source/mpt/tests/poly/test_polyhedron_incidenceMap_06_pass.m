function test_polyhedron_incidenceMap_06_pass
%
% affine set
%

P(1) = ExamplePoly.randHrep('d',3,'ne',3);

M = P.incidenceMap;

if ~isempty(M.incVH)
    error('Must be empty because P is a point.');
end
if ~isempty(M.incRH)
    error('Must be empty because P is a point.');
end


end