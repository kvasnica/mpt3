function test_polyhedron_chebyCenter_07_pass
%
% wrong chebyball for LCP solver
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

load data_problem_bbox_01

xc = Polyhedron('H', P.H).chebyCenter;

if xc.exitflag~=MPTOPTIONS.OK
    error('Wrong solution.');
end
end
