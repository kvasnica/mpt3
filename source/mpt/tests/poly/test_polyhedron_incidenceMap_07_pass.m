function test_polyhedron_incidenceMap_07_pass
%
% positive orthand
%

P = Polyhedron('lb',[0;0;0]);

M = P.incidenceMap;

if isempty(M.incVH)
    error('Must not be empty.');
end
if isempty(M.incRH)
    error('Must not be empty.');
end


end