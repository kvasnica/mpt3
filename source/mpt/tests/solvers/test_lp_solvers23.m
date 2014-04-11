function test_lp_solvers23(solver,tol)
%
%  NaNs in the inequality constraints
%

global MPTOPTIONS

fname = mfilename;
check_LPsolvers;

load lcp_svd_problem

S.solver = solver;

r = mpt_solve(S);

if r.exitflag==MPTOPTIONS.INFEASIBLE
    error('Must be feasible here.');
end

S.quicklp = false;
r = mpt_solve(S);

if r.exitflag==MPTOPTIONS.INFEASIBLE
    error('Must be feasible here.');
end

end