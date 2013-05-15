function test_qp_solvers11(solver, tol)
% testing lagrange multipliers versus quadprog

global MPTOPTIONS

S.H = eye(6);
S.f = [-1.6, 0.25, -1, 1, -0.8, 0.5];
S.A = [-1.3745      -2.3792      -0.8905       1.2538       1.5374      0.24808
     -0.83929     -0.83819      0.13906        -2.52      0.14007    -0.076633
     -0.20864      0.25735     -0.23614      0.58486      -1.8628       1.7382
      0.75591     -0.18383    -0.075459      -1.0081     -0.45419        1.622
      0.37573     -0.16762     -0.35857      0.94428     -0.65207      0.62644
      -1.3454     -0.11699      -2.0776       -2.424      0.10332     0.091814
       1.4819      0.16849     -0.14355     -0.22383     -0.22063     -0.80761
     0.032736     -0.50121       1.3933      0.05807     -0.27904     -0.46134
       1.8705     -0.70508       0.6518     -0.42461     -0.73366       -1.406
       -1.209      0.50816     -0.37713     -0.20292    -0.064534     -0.37453
     -0.78263     -0.42092     -0.66144      -1.5131       -1.444     -0.47091
      -0.7673      0.22913      0.24896      -1.1264      0.61234       1.7513
      -0.1072      -0.9595     -0.38352       -0.815      -1.3235      0.75322
     -0.97706     -0.14604     -0.52848      0.36661     -0.66158     0.064989
     -0.96399      0.74454     0.055388     -0.58611     -0.14611     -0.29276];
 S.b = [2.8504
      0.69342
       1.8205
       1.4579
       2.6739
       2.2863
       1.3694
     0.055511
       2.4642
       1.3341
       1.8463
       2.3758
       2.7654
       2.2146
       0.5288];
 S.Ae = [0.082823       2.2368       0.8633      0.55476       1.2594     -0.31414
         0.76619      0.32689      0.67939       1.0016     0.044151      0.22671];
 S.be = [0;0];
 S.lb = -18*ones(6,1);
 S.ub = 9*ones(6,1);
 S.solver = solver;
 

xd =[     0.78023614108418
        -0.299340888834088
       -0.0705358635961632
         -0.39417347665918
         0.609737734211313
        -0.371190516073596];
fd = -1.63609413387163;
lam_ineq = [             0
         0.707779576465832
                         0
                         0
                         0
                         0
         0.333240686836629
        0.0868990085599875
                         0
                         0
                         0
                         0
                         0
                         0
                         0];
lam_eq = [ 0.108435738869783
           1.1852688062752];
lam_lb = zeros(6,1);
lam_ub = zeros(6,1);

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
