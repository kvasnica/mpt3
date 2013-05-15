function test_lp_solvers21(solver,tol)
%
%  LCP returned result in the magnitude 1e8
%

global MPTOPTIONS

load data_lp_problem_lcp_02

S.solver = solver;

r = mpt_solve(S);


if ~any(r.exitflag==[MPTOPTIONS.UNBOUNDED, MPTOPTIONS.INFEASIBLE])
    error('Must be unbounded here.');
end

end