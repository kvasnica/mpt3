function test_qp_solvers12(solver, tol)
% testing lagrange multipliers versus quadprog

global MPTOPTIONS


load data_qp_problem_lcp_02
S.solver = solver;
 
xd =[ -0.280060134006279
  -0.675564526987549
  -1.000000000000000
  -0.012539696965268
  -0.138049835537777
  -0.565604731630981
   0.020113286631732
  -1.000000000000000];
fd = -2.504038941433265;
lam_ineq = [  0.569476413857505
                   0
                   0
                   0];
lam_eq = [ -0.966749111451911
        0.819859457139407];
lam_lb = [         0
                   0
   0.314816862749490
                   0
                   0
                   0
                   0
   0.754261510588032];    
lam_ub = zeros(8,1);
 

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
