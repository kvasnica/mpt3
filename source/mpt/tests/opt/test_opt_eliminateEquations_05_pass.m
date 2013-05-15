function test_opt_eliminateEquations_05_pass
%
% equalities, lb
%
global MPTOPTIONS

S.A = [];
S.b =[];
S.Ae = randn(5,7);
S.be = rand(5,1);
S.f = ones(7,1);
S.lb = -10*ones(7,1);

% true solution
res = mpt_solve(S);

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
    
if norm(res.obj-S.f'*xn)>MPTOPTIONS.rel_tol
    error('Values of objective functions do not hold.');
end

end
