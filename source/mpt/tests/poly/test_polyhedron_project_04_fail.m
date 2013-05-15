function  test_polyhedron_project_04_fail
%
% empty polyhedron
%

P = Polyhedron;

if ~P.isEmptySet
    error('P must be infeasible.');
end

d = P.project([]);
    


end