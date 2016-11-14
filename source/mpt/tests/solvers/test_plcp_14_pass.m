function test_plcp_14_pass
%
% variable step approach did not find all regions-too many holes were
% presented
%

load data_plcp_varstepproblem_02

r=problem1.solve;

if r.xopt.Num~=24
    error('wrong number of regions.');
end

