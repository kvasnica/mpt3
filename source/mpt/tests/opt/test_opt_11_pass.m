function test_opt_11_pass
%
% opt constructor test
% 
% 

% parameter constraints

problem = Opt('Ath',randn(17,3),'bth',5*rand(17,1),'pF',[-1 2 0.5],'f',-1,'lb',-10);

res = problem.solve;
end