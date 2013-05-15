function test_opt_eliminateEquations_01_pass
%
% simple elimination
%
%  x1-x3=1
%  x2<5
%  x1, x2, x3>=0

global MPTOPTIONS

S.Ae = [1 0 -1];
S.be = 1;
S.A = [0 1 0];
S.b = 5;
S.lb = [0;0;0];

% min 2x1-x2+x3
S.f = [2 -1 1];

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
