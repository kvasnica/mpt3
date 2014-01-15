function test_opt_eliminateEquations_38_pass
%
% MILP with 3 integers 
% 

global MPTOPTIONS

m = 81; n = 23; me=12;
S.A = randn(m,n);
S.b = 31*rand(m,1);
S.f = randn(n,1);
S.Ae = 8*randn(me,n);
S.be = randn(me,1);
S.ub = 11*ones(n,1);
S.lb = -9*ones(n,1);
S.vartype = ['I',repmat('C',1,10),'I',repmat('C',1,10),'I'];

% solve original problem
problem = Opt(S);
r1 = problem.solve;

while r1.exitflag~=MPTOPTIONS.OK
    S.A = randn(m,n);
    S.b = 31*rand(m,1);
    S.f = randn(n,1);
    S.Ae = 8*randn(me,n);
    S.be = randn(me,1);
    S.ub = 11*ones(n,1);
    S.lb = -9*ones(n,1);
    
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