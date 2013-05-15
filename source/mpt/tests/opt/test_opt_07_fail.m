function test_opt_07_fail
%
% opt constructor test
% 
% 

% unconstrained problem

Opt('Ath',randn(2,3),'bth',rand(2,1),'f',-1);