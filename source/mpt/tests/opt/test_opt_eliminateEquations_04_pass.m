function test_opt_eliminateEquations_04_pass
%
% feasibility problem
%
global MPTOPTIONS

S.Ae = randn(2,7);
S.be = randn(2,1);
S.A = randn(5,7);
S.b = rand(5,1);
S.f = [];

% true solution
res=mpt_solve(S);

% construct problem
problem = Opt(S);

% eliminate equations
problem.eliminateEquations;

% solve new problem
r = problem.solve;

% check solution
xn = problem.recover.Y*r.xopt + problem.recover.th;

% for feasibility problem we need to check constraints
if norm(S.Ae*xn - S.be,1)>MPTOPTIONS.rel_tol
    error('Equality constraints do not hold.');
end
if any(S.A*xn>S.b+MPTOPTIONS.rel_tol)
    error('Inequality constraints do not hold.')
end
    

end
