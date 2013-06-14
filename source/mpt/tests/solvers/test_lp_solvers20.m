function test_lp_solvers20(solver, tol)
% testing lagrange multipliers versus linprog

global MPTOPTIONS

fname = mfilename;
check_LPsolvers;

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
S.ub = 5*ones(5,1);
S.solver = solver;
  
xd =[     4.999999999957879
  -3.727237007507199
  -0.171239732783562
   5.000000000076767
   5.000000000004320
];
fd = -14.201875834556059;
lam_ineq = [ 0.000000000000002
   0.000000000000011
   0.724784356897687
   0.000000000000000];
lam_eq = 0.012214218210521;
lam_lb = zeros(5,1);
lam_ub = [0.274420337572900
   0.000000000000003
   0.000000000000003
   0.764492981691102
   1.535125019657981];

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
