function test_opt_26_pass
%
% opt constructor test
% 
% 

% empty matrices

[worked, msg] = run_in_caller('Opt(''A'',[],''b'',[]);');
assert(~worked);
asserterrmsg(msg,'Opt: Empty problem');
