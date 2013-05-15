function test_opt_15_pass
%
% opt constructor test
% 
% 

% parametric QP - no bounds on parameters

problem = Opt('H',[1 0.5;0.5 1],'A',[1 -3],'b',5,'pF',[3;-1]);


end