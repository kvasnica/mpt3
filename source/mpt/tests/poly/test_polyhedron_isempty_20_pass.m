function test_polyhedron_isempty_20_pass
%
% not empty polyhedron, problem with LCP solver
%

load data_lp_solvers_18

if P.isEmptySet
    error('P is not empty.');
end

end