function test_opt_qp2lcp_10_pass
%
% testing multipliers, rank A less than dim
%

global MPTOPTIONS

S.A = randn(3,5);
S.b = [3;5;8];

S.Ae = [0.8 0 -1 3 4];
S.be = 0;
S.f = [1;-2;0;0;0.3];
S.H = diag([1 0.5 0 0 2]);

% problem
problem = Opt(S);
problem.qp2lcp;
r = problem.solve;

S.solver = 'quadprog';
res = mpt_solve(S);

% check multipliers
lineq = problem.recover.lambda.ineqlin.lambdaX*[r.lambda;r.xopt] + problem.recover.lambda.ineqlin.lambdaTh;
leq = problem.recover.lambda.eqlin.lambdaX*[r.lambda;r.xopt] + problem.recover.lambda.eqlin.lambdaTh;
    
if norm(res.lambda.ineqlin-lineq)>MPTOPTIONS.rel_tol
    error('Lagrange multipliers for inequalities do not hold.');
end
if norm(res.lambda.eqlin-leq)>MPTOPTIONS.rel_tol
    error('Lagrange multipliers for equalities do not hold.');
end


end