function test_opt_25_pass
%
% opt constructor test
% 
% 

% no complex numbers

[worked, msg] = run_in_caller('Opt(''A'',[1i 5;-1 2],''b'',[5;3]);');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real matrix.');
