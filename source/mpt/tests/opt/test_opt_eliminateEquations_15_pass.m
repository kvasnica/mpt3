function test_opt_eliminateEquations_15_pass
%
% rank tolerance problem when eliminating equations - 
%
global MPTOPTIONS


load data_problem_elimEquations_05

% direct call to solver
R=mpt_solve(S);

if R.exitflag~=MPTOPTIONS.OK
    error('Solution must exist!');
end

% solve via Opt class
problem = Opt(S);
r = problem.solve;
if r.exitflag~=MPTOPTIONS.OK
    error('Solution must exist!');
end


end
