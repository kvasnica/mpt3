function test_opt_eliminateEquations_46_pass
%
% parametric MIQP with 1 integer, 2 binaries and 2 parameters and
% constraints on binary variables
% 


load data_opt_eliminateEquations_45

% set the rank of equality constraint for continuous variables to 4
S.Ae(1:4,S.vartype=='C')=0;

% the problem contains equalities on the binary/integer variables and
% parameters that cannot be eliminated

problem = Opt(S);

prb = problem.copy;
prb.eliminateEquations;

[~,msg] = run_in_caller('prb.eliminateEquations');

% cannot remove equalities twice
asserterrmsg(msg,'Rank of equality constraint matrix "Ae" is equal zero, you cannot remove equalities.');

prb.qp2lcp;

% solve for some values of the parameter
prb.solver = 'enumplcp';
problem.solver = 'enumplcp';
r1 = prb.solve;
r2 = problem.solve;

if r1.exitflag~=r2.exitflag
    error('The exit statuses must be the same.');
end





end