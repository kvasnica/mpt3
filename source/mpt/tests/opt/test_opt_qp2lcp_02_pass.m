function test_opt_qp2lcp_02_pass
%
%
% qp2lcp with redundancy elimination
%

global MPTOPTIONS

S.A=[  1.8048      0.65089;
      -2.3345      0.34068;
     -0.20446      0.13268;
      0.29604     -0.23329;
      0.44663      0.41649];
S.b = ones(5,1);
S.Ae = [0.64486     -0.28637];
S.be =  0.65702;
S.f = [1;0];
S.H = [1e-13 0; 0 0];
S.lb = [-10;-10];
S.ub = [10;10];

% true solution
res = mpt_solve(S);

% check if the solution is the same when solving LCP
problem = Opt(S);
problem.qp2lcp;

rn=problem.solve;
x = problem.recover.uX*[rn.lambda;rn.xopt]+problem.recover.uTh;

% primal check
if norm(res.xopt-x,1)>MPTOPTIONS.rel_tol
    error('QP2LCP failed.');
end

% dual check
lam_ineq = problem.recover.lambda.ineqlin.lambdaX*[rn.lambda;rn.xopt] + problem.recover.lambda.ineqlin.lambdaTh;
lam_eq = problem.recover.lambda.eqlin.lambdaX*[rn.lambda;rn.xopt] + problem.recover.lambda.eqlin.lambdaTh;
lam_l = problem.recover.lambda.lower.lambdaX*[rn.lambda;rn.xopt] + problem.recover.lambda.lower.lambdaTh;
lam_u = problem.recover.lambda.upper.lambdaX*[rn.lambda;rn.xopt] + problem.recover.lambda.upper.lambdaTh;

if norm(lam_ineq-res.lambda.ineqlin,Inf)>MPTOPTIONS.abs_tol
    error('Lagrange multipliers for inequalities do not hold.');
end
if norm(lam_eq-res.lambda.eqlin,Inf)>MPTOPTIONS.abs_tol
    error('Lagrange multipliers for equalities do not hold.');
end
if norm(lam_l-res.lambda.lower,Inf)>MPTOPTIONS.abs_tol
    error('Lagrange multipliers for lower bound do not hold.');
end
if norm(lam_u-res.lambda.upper,Inf)>MPTOPTIONS.abs_tol
    error('Lagrange multipliers for upper bound do not hold.');
end



end