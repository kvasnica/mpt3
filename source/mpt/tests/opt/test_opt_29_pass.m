function test_opt_29_pass
%
% opt constructor test
% 
% 

% no structures, please

[worked, msg] = run_in_caller('Opt(''A'',{[1 2;3 -4]},''lb'',[0;0]);');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real matrix.');
