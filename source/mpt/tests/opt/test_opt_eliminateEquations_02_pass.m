function test_opt_eliminateEquations_02_pass
%
% random numbers
%

global MPTOPTIONS

S.Ae = randn(6,12);
S.be = randn(6,1);
S.A = randn(2,12);
S.b = [4;5];
S.lb = -5*ones(12,1);
S.f = ones(12,1);

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

if norm(res.xopt-xn,Inf)>MPTOPTIONS.abs_tol
    error('Wrong elimination.');
end

end
