function test_opt_qp2lcp_11_pass
%
% comparing multipliers, rank A bigger than dim
%

global MPTOPTIONS

S.A = [1 3 -0.8 3 -0.5;
       0 -1 2 3.6 0;
       -5 -3 1 0 -2;
       randn(5)];
S.b = [3;5;8;rand(5,1)];

S.Ae = [0.8 0 -1 3 4];
S.be = 0;
S.f = [1;-2;0;0;0.3];
S.H = diag([1 0.5 0 0 2]);

% problem
problem = Opt(S);
problem.qp2lcp(false);
r = problem.solve;

res = mpt_solve(S);

% without redundancy elimination
lineq = problem.recover.lambda.ineqlin.lambdaX*[r.lambda;r.xopt] + problem.recover.lambda.ineqlin.lambdaTh;
leq = problem.recover.lambda.eqlin.lambdaX*[r.lambda;r.xopt] + problem.recover.lambda.eqlin.lambdaTh;
    
if norm(res.lambda.ineqlin-lineq)>MPTOPTIONS.rel_tol
    error('Lagrange multipliers for inequalities do not hold.');
end
if norm(res.lambda.eqlin-leq)>MPTOPTIONS.rel_tol
    error('Lagrange multipliers for equalities do not hold.');
end

pn = Opt(S);
rr=pn.solve;
pn.qp2lcp;
rn=pn.solve;

% with redundancy elimination
nlineq = pn.recover.lambda.ineqlin.lambdaX*[rn.lambda;rn.xopt] + pn.recover.lambda.ineqlin.lambdaTh;
nleq = pn.recover.lambda.eqlin.lambdaX*[rn.lambda;rn.xopt] + pn.recover.lambda.eqlin.lambdaTh;
    
if norm(rr.lambda.ineqlin-nlineq)>MPTOPTIONS.rel_tol
    error('Lagrange multipliers for inequalities do not hold.');
end
if norm(rr.lambda.eqlin-nleq)>MPTOPTIONS.rel_tol
    error('Lagrange multipliers for equalities do not hold.');
end


end