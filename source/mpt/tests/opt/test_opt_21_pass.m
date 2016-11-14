function test_opt_21_pass
%
% opt constructor test
% MPMIQP, choose solver first, change later
% 

sdpvar x
binvar u
mptopt('plpsolver', 'MPLP');

problem = Opt([-1 <= x+u <= 1; -1<=x<=1], x+u, x, u);

if ~strcmp(problem.solver,'MPLP')
    error('The solver here is MPLP.');
end

mptopt('plpsolver', 'PLCP');

a=mptopt;
if ~strcmp(a.plpsolver,'PLCP')
    error('The global solver should be PLCP.');
end

end