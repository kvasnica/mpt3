function test_opt_08_fail 
%
% opt constructor test
% 
% 

% unconstrained parametric LP

Opt('f',randn(5,1),'pF',sparse(randn(5,2)),'Ath',randn(7,2),'bth',ones(7,1));