function test_qp_solvers13(solver, tol)
% testing lagrange multipliers versus quadprog

global MPTOPTIONS

fname = mfilename;
check_QPsolvers;

load data_qp_problem_lcp_03
S.solver = solver;
 
xd =[ -6.428942299820529
  -6.437987660339171
  -0.099411141932617
   5.000000000000000
   0.653023677830556
   5.000000000000000
  -9.082477877879644
   5.000000000000000 ];
fd = -11.853820592762702;
lam_ineq = [       0
                   0
                   0
                   0
                   0
                   0
                   0
   0.934020607124857
                   0
                   0
                   0
                   0
                   0
                   0 ];
lam_eq = [  -0.018622179039012
  -0.520027913024873];
lam_lb = zeros(8,1);    
lam_ub = [         0
                   0
                   0
   0.648465168867314
                   0
   0.059321770422378
                   0
   0.076292864903366];
 

% call mpt_solve
R = mpt_solve(S);

if R.exitflag~=MPTOPTIONS.OK
    error('Result should be feasible.');
end

if norm(R.xopt - xd,Inf)>tol
    error('Solution does not hold.');
end
if norm(R.obj - fd,Inf)>tol
    error('Objective value does not hold.');
end
if norm(R.lambda.ineqlin - lam_ineq,Inf)>tol
    error('Inequality multipliers do not hold.');
end
if norm(R.lambda.eqlin - lam_eq,Inf)>tol
    error('Equality multipliers do not hold.');
end
if norm(R.lambda.lower - lam_lb,Inf)>tol
    error('Lower bound multipliers do not hold.');
end
if norm(R.lambda.upper - lam_ub,Inf)>tol
    error('Upper bound multipliers do not hold.');
end


end
