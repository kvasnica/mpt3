function test_opt_eliminateEquations_14_pass
%
% rank tolerance problem when eliminating equations - 
% if the problem appears, the rank is recomputed with incomplete LU
% factorization otherwise, all possible permutations are computed 
%
global MPTOPTIONS


load data_problem_elimEquations_04

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
