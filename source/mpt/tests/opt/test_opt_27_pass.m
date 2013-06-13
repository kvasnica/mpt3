function test_opt_27_pass
%
% opt constructor test
% 
% 

% Nan in input argument

[worked, msg] = run_in_caller('Opt(''A'',[1 NaN;2 4],''b'',2,''lb'',[-Inf;-Inf]);');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real matrix.');
