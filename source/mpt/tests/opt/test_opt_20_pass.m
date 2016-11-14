function test_opt_20_pass
%
% opt constructor test
% MPMILP, choose solver first
% 

sdpvar x
binvar u
mptopt('plpsolver', 'MPLP');

problem = Opt([-1 <= x + u <= 1; -1<=x<=1; 0<=u<=1], norm(x,1), x, u);

if ~strcmp(problem.problem_type,'MILP')
    error('This must be MPMILP.');
end
if ~strcmp(problem.solver,'MPLP')
    error('The solver here is MPLP.');
end
mptopt('plpsolver', 'PLCP');

end