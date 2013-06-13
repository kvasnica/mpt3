function test_opt_31_pass
%
% opt constructor test
% 
% 

% unconstrained parametric LP

[worked, msg] = run_in_caller('Opt(''f'',randn(5,1),''pF'',sparse(randn(5,2)),''Ath'',randn(7,2),''bth'',ones(7,1));');
assert(~worked);
asserterrmsg(msg,'Opt: Unconstrained problem.');
