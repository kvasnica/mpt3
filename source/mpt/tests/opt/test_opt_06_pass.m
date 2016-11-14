function test_opt_06_pass
%
% opt constructor test
% 
% 

% parametric QP

Opt('M',[1 0.5;0.5 1],'q',[0.4 -9],'Q',[3;-1],'Ath',[1;-1],'bth',[1;1]);