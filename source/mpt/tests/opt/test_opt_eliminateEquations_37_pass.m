function test_opt_eliminateEquations_37_pass
%
% MILP with 1 integer
% 

global MPTOPTIONS

m = 13; n = 5; me=2;
S.A = randn(m,n);
S.b = 13*rand(m,1);
S.f = randn(n,1);
S.Ae = 5*randn(me,n);
S.be = randn(me,1);
S.ub = 5*ones(n,1);
S.lb = -4*ones(n,1);
S.vartype = 'CCCCI';

% solve original problem
problem = Opt(S);
r1 = problem.solve;

while r1.exitflag~=MPTOPTIONS.OK
    S.A = randn(m,n);
    S.b = 13*rand(m,1);
    S.f = randn(n,1);
    S.Ae = 5*randn(me,n);
    S.be = randn(me,1);
    S.ub = 5*ones(n,1);
    S.lb = -4*ones(n,1);
    
    % solve original problem
    problem = Opt(S);
    r1 = problem.solve;

end
    
% solve reduced problem
problem.eliminateEquations;
r2 = problem.solve;

% compare solutions
xopt = problem.recover.Y*r2.xopt + problem.recover.th;

if norm(r1.xopt-xopt,Inf)>MPTOPTIONS.abs_tol
    error('The MIQP solutions do not hold.');
end


end