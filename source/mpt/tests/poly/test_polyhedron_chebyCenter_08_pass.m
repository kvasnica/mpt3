function test_polyhedron_chebyCenter_08_pass
%
% wrong chebyball for LCP solver
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

load data_problem_bbox_02

xc = P.chebyCenter;

if xc.exitflag~=MPTOPTIONS.OK
    error('Wrong solution.');
end
end
