function test_opt_qp2lcp_09_pass
%
% rank of A less than dim
%

global MPTOPTIONS

S.A = [1 1 0 -3 0.5;
       0.1 -1 2 -8 0;
       [0.1 -1 2 -8 0]*2-1];
S.b = [2;3;3*2-1];
S.Ae = randn(1,5);
S.be = rand(1);
S.f = [1;-2;0;0;0.3];
S.H = diag([0.1 4 0 0 2]);

% true solution
res = mpt_solve(S);

% problem
problem = Opt(S);
s = problem.solve;

% convert to LCP
problem.qp2lcp;
r = problem.solve;

% compare
xopt = problem.recover.uX*[r.lambda;r.xopt] + problem.recover.uTh;

obj = 0.5*xopt'*S.H*xopt + S.f'*xopt;

if norm(res.obj-obj,1)>MPTOPTIONS.abs_tol
    error('Solution does not hold.');
end

% check multipliers
lineq = problem.recover.lambda.ineqlin.lambdaX*[r.lambda;r.xopt] + problem.recover.lambda.ineqlin.lambdaTh;
leq = problem.recover.lambda.eqlin.lambdaX*[r.lambda;r.xopt] + problem.recover.lambda.eqlin.lambdaTh;
    
if norm(s.lambda.ineqlin-lineq)>MPTOPTIONS.rel_tol
    error('Lagrange multipliers for inequalities do not hold.');
end
if norm(s.lambda.eqlin-leq)>MPTOPTIONS.rel_tol
    error('Lagrange multipliers for equalities do not hold.');
end

end