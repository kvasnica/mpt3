function test_opt_eliminateEquations_47_pass
%
% parametric MIQP with 1 integer, 2 binaries and 2 parameters and
% constraints on binary variables
% 

global MPTOPTIONS

load data_opt_eliminateEquations_45

% set the rank of equality constraint for continuous variables to 5
S.Ae([1:4,6],S.vartype=='C')=0;

% remove lower/upper bounds to call qp2lcp transformation with x+, x- variables
R = S;
R.lb = [];
R.ub = [];

% the problem contains equalities on the binary/integer variables and
% parameters that cannot be eliminated
problem = Opt(R);
problem.qp2lcp;

% solve for some values of the parameter
problem.solver = 'enumplcp';
r1 = problem.solve;

if r1.exitflag~=MPTOPTIONS.INFEASIBLE
    error('The result is infeasible.');
end

% transform to lcp with factorization of basic variables
problem = Opt(S);
problem.solver = 'enumplcp';
r2 = problem.solve;

if r2.exitflag~=MPTOPTIONS.INFEASIBLE
    error('The result is infeasible.');
end





end