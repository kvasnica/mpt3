function test_opt_qp2lcp_13_pass
%
% compare multipliers parametrically
%

global MPTOPTIONS

S.A = [1 3 -0.8 3 -0.5;
       0 -1 2 3.6 0;
       -5 -3 1 0 -2;
      -1.6931     -0.75809      0.76286      0.52449     -0.16689;
      0.71919      0.44266      -1.2882       1.3643     -0.81623;
       1.1418       0.9111     -0.95296      0.48204       2.0941;
       1.5519      -1.0741      0.77817     -0.78707     0.080153;
       1.3836      0.20176   -0.0063311        0.752      -0.9373];
S.b = [3;5;8; 0.63574; 1.682; 0.59363;  0.79015;  0.10525];
S.pB = [0 1 -2;0 0 1; -1 0.2 4;
    -0.15858     -0.68548    -0.041007;
      0.87091     -0.26839      -2.2476;
     -0.19476      -1.1883     -0.51078;
     0.075474      0.24858      0.24924;
     -0.52663      0.10245       0.3692];
S.lb = zeros(5,1);
S.Ae = [0.8 0 -1 3 4];
S.be = 0;
S.pE = [0.2 0 0];
S.f = [1;-2;0;0;0.3];
S.pF = [0.1792      0.48519     -0.32245;
    -0.037283      0.59875     -0.38237;
      -1.6033    -0.086031     -0.95337;
      0.33937      0.32529      0.23358;
     -0.13113     -0.33514       1.2352];
S.H = diag([1 0.5 2 0.2 2]);
S.Ath = [-1.2027       -1.535       1.0382;
     -0.85497       1.7225       1.0565;
     -0.97303      -1.0729       1.9004;
       2.3183     -0.51785     -0.82828;
       -1.373      0.22431      -1.0836;
    -0.079846      -1.6943      -0.9858;
     -0.74291       0.4604     -0.57539;
       1.1427      -1.6852       2.1665;
            0           -1            0;
            0            1            0;
            0            0            1];
S.bth = 10*ones(11,1);

% problem
problem = Opt(S);
problem.qp2lcp;
r = problem.solve;

% compare solutions
for i=1:r.xopt.Num

    % point inside P
    xc = chebyCenter(r.xopt.Set(i));    
    
    % z
    xopt = feval(r.xopt.Set(i),xc.x,'z');
    % w
    lambda = feval(r.xopt.Set(i),xc.x,'w');
    
    % solve QP    
    p.A = S.A;
    p.b = S.b + S.pB*xc.x;
    p.Ae = S.Ae;
    p.be = S.be + S.pE*xc.x;
    p.H = S.H;
    p.f = S.f + S.pF*xc.x;
    p.lb  = S.lb;
    
    res = mpt_solve(p);
    
    x = problem.recover.uX*[lambda;xopt] + problem.recover.uTh*[xc.x; 1];
    
    if norm(res.xopt-x,1)>MPTOPTIONS.rel_tol
        error('Solution does not hold.');
    end
    
    % get multpliers
    lineq = problem.recover.lambda.ineqlin.lambdaX*[lambda;xopt] + problem.recover.lambda.ineqlin.lambdaTh*[xc.x; 1];
    leq = problem.recover.lambda.eqlin.lambdaX*[lambda;xopt] + problem.recover.lambda.eqlin.lambdaTh*[xc.x; 1];
    lb = problem.recover.lambda.lower.lambdaX*[lambda;xopt] + problem.recover.lambda.lower.lambdaTh*[xc.x; 1];
    
    if norm(res.lambda.ineqlin-lineq)>MPTOPTIONS.rel_tol
        error('Lagrange multipliers for inequalities do not hold.');
    end
    if norm(res.lambda.eqlin-leq)>MPTOPTIONS.rel_tol
        error('Lagrange multipliers for equalities do not hold.');
    end
    if norm(res.lambda.lower-lb)>MPTOPTIONS.rel_tol
        error('Lagrange multipliers for lower bound do not hold.');
    end
    
end
end