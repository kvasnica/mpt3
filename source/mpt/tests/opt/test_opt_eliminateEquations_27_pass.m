function test_opt_eliminateEquations_27_pass
%
% MIQP with 1 binary
% 

global MPTOPTIONS

m = 5; n = 2; me=1;
S.A = randn(m,n);
S.b = 13*rand(m,1);
Q = rand(n);
S.H = 0.5*(Q'*Q);
S.f = randn(n,1);
S.Ae = 5*randn(me,n);
S.be = randn(me,1);
S.vartype = 'CB';

% formulate problem and solve with equality constraints
problem = Opt(S);
r1 = problem.solve;

% eliminate equations and solve reduced problem
problem.eliminateEquations;
r2 = problem.solve;

% compare solutions
xopt = problem.recover.Y*r2.xopt + problem.recover.th;

if r1.exitflag == MPTOPTIONS.OK
    if norm(r1.xopt-xopt,Inf)>MPTOPTIONS.abs_tol
        error('The MIQP solutions do not hold.');
    end    
end

end