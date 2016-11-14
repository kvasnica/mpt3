function test_lp_solvers13(solver, tol)
% equality-rank inconsistent LP

global MPTOPTIONS

fname = mfilename;
check_LPsolvers;

n=4;

% equality constraints
S.Ae = [1 2 3 4; -5 6 -9 0;2 4 6 8]; % last row is 2x first row
S.be = [1;2;3]; % last element should be 2 to be consistent
 
% inequality constraints just simple bounds
S.lb = -10*ones(n,1);
S.ub = 10*ones(n,1);
S.A =[];
S.b =[];

% random cost function
S.f = randn(n,1);

% assign solver
S.solver = solver;

% call mpt_solve
R = mpt_solve(S);

% compare results
if R.exitflag~=MPTOPTIONS.INFEASIBLE
    error('Results should be infeasible.');
end

%mbg_asserttolequal(R.xopt,p.xopt,tol);
%mbg_asserttolequal(R.obj,p.fopt,tol);

end