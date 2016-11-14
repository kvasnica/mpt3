function test_opt_eliminateEquations_31_pass
%
% MIQP case with the upper bound
% 

global MPTOPTIONS

load data_opt_eliminateEquations_31

% formulate problem and solve with equality constraints
problem = Opt(S);
r1 = problem.solve;

% eliminate equations and solve reduced problem
problem.eliminateEquations;
r2 = problem.solve;

% compare solutions
xopt = problem.recover.Y*r2.xopt + problem.recover.th;

if r1.exitflag == MPTOPTIONS.OK
    if norm(S.f'*r1.xopt-S.f'*xopt,Inf)>MPTOPTIONS.rel_tol
        error('The MIQP objectives do not hold.');
    end
    if norm(r1.xopt-xopt,Inf)>MPTOPTIONS.rel_tol
        error('The MIQP optimizers do not hold.');
    end
end
end