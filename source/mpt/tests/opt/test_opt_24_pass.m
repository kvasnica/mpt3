function test_opt_24_pass
%
% opt constructor test
% 
% 

% no arguments

[worked, msg] = run_in_caller('Opt');
assert(~worked);
asserterrmsg(msg,'Empty problems not supported.');
