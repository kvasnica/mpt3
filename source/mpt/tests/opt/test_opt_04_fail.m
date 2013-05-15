function test_opt_04_fail
%
% opt constructor test
% 
% 

% Nan in input argument

Opt('A',[1 NaN;2 4],'b',2,'lb',[-Inf;-Inf]);