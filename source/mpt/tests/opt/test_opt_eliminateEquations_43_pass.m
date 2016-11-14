function test_opt_eliminateEquations_43_pass
%
% MIQP with 4 integers and 3 binaries
%

% the solution can differ if the cost function has too large values because
% the solvers may run into numerical problems - see for example 
%
% data_opt_eliminateEquations_43 
%
% with GUROBI solver

global MPTOPTIONS

m = 51; n = 32; me=19;
S.A = randn(m,n);
S.b = 5*rand(m,1);
Q = randn(n);
S.H = 0.5*(Q'*Q);
S.f = randn(n,1);
S.Ae = 8*randn(me,n);
S.be = randn(me,1);
S.ub = 7*ones(n,1);
S.lb = -5*ones(n,1);
S.vartype = ['I',repmat('C',1,5),'B',repmat('C',1,5),'IBI',repmat('C',1,10),'B',repmat('C',1,5),'I'];

% solve original problem
problem = Opt(S);
r1 = problem.solve;

while r1.exitflag~=MPTOPTIONS.OK
    S.A = randn(m,n);
    S.b = 5*rand(m,1);
    Q = randn(n);
    S.H = 0.5*(Q'*Q);
    S.f = randn(n,1);
    S.Ae = 8*randn(me,n);
    S.be = randn(me,1);
    S.ub = 7*ones(n,1);
    S.lb = -5*ones(n,1);
    
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