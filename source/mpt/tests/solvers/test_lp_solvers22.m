function test_lp_solvers22(solver,tol)
%
%  LCP returned infeasible result, which is not
%

global MPTOPTIONS

load data_lp_problem_lcp_03

S.solver = solver;

r = mpt_solve(S);


if r.exitflag==MPTOPTIONS.INFEASIBLE
    error('Must be feasible here.');
end

end