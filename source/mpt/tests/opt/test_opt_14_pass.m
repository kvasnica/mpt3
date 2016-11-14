function test_opt_14_pass
%
% formulate MILP
%

load data_lp_problem_lcp_01

problem=Opt('A',A,'b',B,'Ae',Aeq,'be',Beq,'f',f,'vartype','CBBCCC');

if ~strcmp(problem.problem_type,'MILP')
    error('Should be MILP on the output.');
end

end