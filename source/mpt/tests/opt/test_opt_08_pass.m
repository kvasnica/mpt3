function test_opt_08_pass
%
% opt constructor test
% 
% 

% all parameters

Opt('H',sparse([1 0.1;0.1 1]),'f',[-1 0],'pF',[0.2 -1.9 -0.8;randn(1,3)],...
    'A',randn(10,2), 'b', ones(10,1), 'pB', randn(10,3), ...
    'Ae',sparse(randn(1,2)),'be',rand(1,1),'pE',sparse(randn(1,3)),...
    'lb',[-10;-100],'ub',[100;123]);