function test_plcp_13_pass
%
% variable step approach did not find all regions
% check with fixed step- the region 183 was missing or the region that
% contains the point [-9.3; 23.01]
%

global MPTOPTIONS

load data_plcp_varstepproblem_01

r=problem.solve;

if r.xopt.Num~=293
    error('wrong number of regions.');
end

