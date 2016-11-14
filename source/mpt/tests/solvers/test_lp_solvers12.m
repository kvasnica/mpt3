function test_lp_solvers12(solver, tol)
% test overdetermined, infeasible system

global MPTOPTIONS

fname = mfilename;
check_LPsolvers;

n = 40; % variables
 m = 120; % inequality constraints
 me = 42; % equality constraints

% equality constraints
S.Ae = randn(me,n);
S.be = ones(me,1);
 
% inequality constraints create a large polytope with a lot of redundant
% hyperplanes
S.A = randn(m,n);
S.b = 10*ones(m,1);

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