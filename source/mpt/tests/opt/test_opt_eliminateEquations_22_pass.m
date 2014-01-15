function test_opt_eliminateEquations_22_pass
%
% MILP with 3 binaries
% 

global MPTOPTIONS
load data_opt_eliminateEquations_22

% formulate problem and solve with equality constraints
problem = Opt(S);
r1 = problem.solve;

% eliminate equations and solve reduced problem
problem.eliminateEquations;
r2 = problem.solve;

% compare solutions
xopt = problem.recover.Y*r2.xopt + problem.recover.th;

if norm(r1.xopt-xopt,Inf)>MPTOPTIONS.abs_tol
    error('The MILP solutions do not hold.');
end

end