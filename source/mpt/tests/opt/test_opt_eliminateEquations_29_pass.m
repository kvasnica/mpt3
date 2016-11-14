function test_opt_eliminateEquations_29_pass
%
% MIQP with 3 binaries, 5 continous variables
% 

global MPTOPTIONS

m = 41; n = 8; me=3;
S.A = randn(m,n);
S.b = 13*rand(m,1);
Q = randn(n);
S.H = 0.5*(Q'*Q);
S.f = randn(n,1);
S.Ae = 5*randn(me,n);
S.be = randn(me,1);

%% assume now that some variables are binary
S.vartype = 'CBCBCBCC';

% formulate problem and solve with equality constraints
problem = Opt(S);
r1 = problem.solve;

% eliminate equations and solve reduced problem
problem.eliminateEquations;
r2 = problem.solve;

% compare solutions
xopt = problem.recover.Y*r2.xopt + problem.recover.th;

if r1.exitflag ~= r2.exitflag
    error('The exitflags do not hold.');
end
if r1.exitflag == MPTOPTIONS.OK
    if norm(r1.xopt-xopt,Inf)>MPTOPTIONS.abs_tol
        error('The MIQP solutions do not hold.');
    end
end

end