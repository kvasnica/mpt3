function test_opt_03_pass
%
% opt constructor test
% 
% 

% QP

Opt('H',speye(2),'f',[1 -2],'A',[-0.3 5],'b',5);