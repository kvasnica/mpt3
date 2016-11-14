function test_plcp_15_pass
%
% variable step approach did not find all regions- three regions are
% missing located in the bottom around [3.6,-34.2]
%

load data_plcp_varstepproblem_03

r=problem.solve;

if r.xopt.Num~=253
    error('wrong number of regions.');
end

