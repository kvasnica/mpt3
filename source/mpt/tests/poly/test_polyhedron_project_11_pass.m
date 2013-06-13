function test_polyhedron_project_11_pass
%
% empty polyhedron
%

P = Polyhedron;

if ~P.isEmptySet
    error('P must be infeasible.');
end

[worked, msg] = run_in_caller('d = P.project([]); ');
assert(~worked);
asserterrmsg(msg,'Cannot project with empty polyhedra.');
    


end