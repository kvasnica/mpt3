function test_opt_eliminateEquations_30_pass
%
% MIQP with 2 continuous and 8 binary variables
% 

global MPTOPTIONS

m = 25; n = 10; me=2;
S.A = randn(m,n);
S.b = 13*rand(m,1);
Q = rand(n);
T = Q'*Q;
S.H = 0.5*T;
S.f = randn(n,1);
S.Ae = 5*randn(me,n);
S.be = randn(me,1);
S.ub = 100*rand(n,1);
S.vartype = 'BBCBBBBBCB';

% formulate problem and solve with equality constraints
problem = Opt(S);
r1 = problem.solve;

% eliminate equations and solve reduced problem
problem.eliminateEquations;
r2 = problem.solve;

% compare solutions
xopt = problem.recover.Y*r2.xopt + problem.recover.th;

if r1.exitflag == MPTOPTIONS.OK
    if norm(S.f'*r1.xopt-S.f'*xopt,Inf)>MPTOPTIONS.rel_tol
        error('The MIQP objectives do not hold.');
    end
    if norm(r1.xopt-xopt,Inf)>MPTOPTIONS.rel_tol
        error('The MIQP optimizers do not hold.');
    end
end
end