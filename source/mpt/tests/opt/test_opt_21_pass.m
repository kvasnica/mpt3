function test_opt_21_pass
%
% opt constructor test
% MPMIQP, choose solver first, change later
% 

sdpvar x
binvar u
mptopt('pqpsolver', 'MPQP');

problem = Opt([-1 <= x+u <= 1; -1<=x<=1], x+u, x, u);

mptopt('pqpsolver', 'PLCP');

if ~strcmp(problem.solver,'MPQP')
    error('The solver here is MPQP.');
end

a=mptopt;
if ~strcmp(a.pqpsolver,'PLCP')
    error('The global solver should be PLCP.');
end

end