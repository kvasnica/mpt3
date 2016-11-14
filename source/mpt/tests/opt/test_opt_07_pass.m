function test_opt_07_pass
%
% opt constructor test
% 
% 

% feasibility

Opt('Ae',randn(6,10),'be',rand(6,1),'pE',randn(6,2),'Ath',[eye(2);-eye(2)],'bth',5*ones(4,1));