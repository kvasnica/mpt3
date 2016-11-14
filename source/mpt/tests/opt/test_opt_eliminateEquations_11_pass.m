function test_opt_eliminateEquations_11_pass
%
% rank tolerance problem when eliminating equations - therefore in
% mpt_solve and mpt_call_lcp the "rank" operator is treated with
% MPTOPTIONS.abs_tol
%
global MPTOPTIONS


load data_problem_elimEquations_01

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
