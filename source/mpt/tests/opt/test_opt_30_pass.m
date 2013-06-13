function test_opt_30_pass
%
% opt constructor test
% 
% 

% unconstrained problem

[worked, msg] = run_in_caller('Opt(''Ath'',randn(2,3),''bth'',rand(2,1),''f'',-1);');
assert(~worked);
asserterrmsg(msg,'Opt: Unconstrained problem.');
