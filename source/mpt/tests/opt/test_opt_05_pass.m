function test_opt_05_pass
%
% opt constructor test
% 
% 

% LP

Opt('lb',[-1 -1],'ub',[1 1],'Ae',[1 0],'be',1,'f',[0.1 0]);