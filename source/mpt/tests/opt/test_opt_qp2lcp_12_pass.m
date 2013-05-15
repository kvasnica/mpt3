function test_opt_qp2lcp_12_pass
%
% compare multipliers parametrically - degenerate case
%

global MPTOPTIONS

S.A = [1 3 -0.8 3 -0.5;
       0 -1 2 3.6 0;
       -5 -3 1 0 -2];
S.b = [3;5;8];
S.pB = [0 1 -2;0 0 1; -1 0.2 4];

S.Ae = [0.8 0 -1 3 4];
S.be = 0;
S.pE = [0.2 0 0];
S.f = [1;-2;0;0;0.3];
S.H = diag([1 0.5 0 0 2]);
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
    
    % xopt
    xopt = feval(r.xopt.Set(i),xc.x,'z');
    % lambda
    lambda = feval(r.xopt.Set(i),xc.x,'w');
    
    % solve QP    
    p.A = S.A;
    p.b = S.b + S.pB*xc.x;
    p.Ae = S.Ae;
    p.be = S.be + S.pE*xc.x;
    p.H = S.H;
    p.f = S.f;
    
    res = mpt_solve(p);
    
    x = problem.recover.uX*[lambda;xopt] + problem.recover.uTh*[xc.x; 1];
    
    % solution does not hold because we have multiple solutions for the 
    % same optimal objective function
%     if norm(x-res.xopt)>MPTOPTIONS.rel_tol
%         error('Solution does not hold.');
%     end
    
    obj1 = 0.5*x'*S.H*x + S.f'*x;
    if norm(obj1-res.obj,1)>MPTOPTIONS.rel_tol
        error('Objective value does not hold.');
    end
    
    % get multpliers
    lineq = problem.recover.lambda.ineqlin.lambdaX*[lambda;xopt] + problem.recover.lambda.ineqlin.lambdaTh*[xc.x; 1];
    leq = problem.recover.lambda.eqlin.lambdaX*[lambda;xopt] + problem.recover.lambda.eqlin.lambdaTh*[xc.x; 1];
    
    if norm(res.lambda.ineqlin-lineq)>MPTOPTIONS.rel_tol
        error('Lagrange multipliers for inequalities do not hold.');
    end
    if norm(res.lambda.eqlin-leq)>MPTOPTIONS.rel_tol
        error('Lagrange multipliers for equalities do not hold.');
    end

    
    
end
end