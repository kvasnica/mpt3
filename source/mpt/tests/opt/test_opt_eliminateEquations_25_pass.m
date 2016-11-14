function test_opt_eliminateEquations_25_pass
%
% MILP with 2 equality constraints and 2 continuous variables to remove
% 

global MPTOPTIONS

load data_opt_eliminateEquations_25

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