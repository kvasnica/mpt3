function test_opt_17_pass
%
% opt constructor test
% 
% 

% feasibility MILP

p = Opt('A', [1; -1], 'b', [2; 2], 'f',[], 'vartype', 'B');

if ~strcmp(p.problem_type,'MILP')
    error('This is MILP problem.');
end


end