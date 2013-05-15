function test_lp_solvers19(solver, tol)
% testing lagrange multipliers versus linprog

global MPTOPTIONS

S.f = [ -0.33595      0.54149      0.93211     -0.57025      -1.4986];
S.A = [    -0.050346     -0.33077      0.66665      -1.4886     -0.88844
      0.55302      0.79515      -1.3926      0.55854     -0.98652
     0.083498      -0.7848      -1.3006     -0.27735    -0.071618
       1.5775      -1.2631     -0.60502      -1.2937      -2.4146];
S.b = [2.8504
      0.69342
       1.8205
       1.4579];
S.Ae = [0.082823       2.2368       0.8633      0.55476       1.2594];
S.be = 1;
S.lb = -ones(5,1);
S.solver = solver;
  
xd =[  3.263387615884209
  -0.999999999991710
  -0.999999999952974
   1.300218489118824
   2.468244591398225
];
fd = -7.010296007597368;
lam_ineq = [   0.000000000003570
   0.210559745027595
   1.216353690665509
   0.000000000012772];
lam_eq = [1.424038604354233];
lam_lb = [  0.000000000006748
   2.939611755026635
   0.286267416128673
   0.000000000011350
   0.000000000007004];
lam_ub = zeros(5,1);

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
