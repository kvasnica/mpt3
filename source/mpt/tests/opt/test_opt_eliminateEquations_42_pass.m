function test_opt_eliminateEquations_42_pass
%
% MILP with 1 integer and 2 binaries
% 

global MPTOPTIONS

m = 45; n = 23; me=12;
S.A = randn(m,n);
S.b = 5*rand(m,1);
S.f = randn(n,1);
S.Ae = 8*randn(me,n);
S.be = randn(me,1);
S.ub = 8*ones(n,1);
S.lb = -6*ones(n,1);
S.vartype = ['I',repmat('C',1,10),'B',repmat('C',1,10),'B'];

% solve original problem
problem = Opt(S);
r1 = problem.solve;

while r1.exitflag~=MPTOPTIONS.OK
    S.A = randn(m,n);
    S.b = 5*rand(m,1);
    S.f = randn(n,1);
    S.Ae = 8*randn(me,n);
    S.be = randn(me,1);
    S.ub = 8*ones(n,1);
    S.lb = -6*ones(n,1);
    
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
    % for LP check the cost function as well
    obj = S.f'*xopt;
    if norm(r1.obj - obj,Inf)>MPTOPTIONS.abs_tol
        error('The MILP solutions do not hold.');
    end
end


end