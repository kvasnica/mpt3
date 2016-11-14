function test_opt_eliminateEquations_03_pass
%
% too many equalities, but consistent
%

global MPTOPTIONS

Ae = randn(7,18);
be = 5*rand(7,1);

S.Ae = [Ae; 2*Ae-3];
S.be = [be; 2*be-3];
S.A =[];
S.b = [];
S.lb = -10*ones(18,1);
S.f = ones(18,1);

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

% checking objective value because the solution might be degenerate
if norm(res.obj-S.f'*xn,Inf)>MPTOPTIONS.abs_tol
    error('Wrong elimination.');
end

end
