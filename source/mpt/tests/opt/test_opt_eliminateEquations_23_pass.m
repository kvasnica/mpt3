function test_opt_eliminateEquations_23_pass
%
% MILP with 4 binaries - degenerate case
% 

global MPTOPTIONS

m = 65; n = 13; me=6;
S.A = randn(m,n);
S.b = 13*rand(m,1);
S.f = zeros(n,1);
S.f([1,4,7,8]) = -[1;1;1;1]; % provide cost on the binaries only
S.Ae = 5*randn(me,n);
S.be = randn(me,1);

%% assume now that some variables are binary
S.vartype = 'BCCBCCBBCCCCC';

% formulate problem and solve with equality constraints
problem = Opt(S);
r1 = problem.solve;

% eliminate equations and solve reduced problem
problem.eliminateEquations;
r2 = problem.solve;

% compare solutions
xopt = problem.recover.Y*r2.xopt + problem.recover.th;

% solution can be different so we compare only cost function
if norm(S.f'*r1.xopt-S.f'*xopt,Inf)>MPTOPTIONS.abs_tol
    error('The MILP solutions do not hold.');
end

end