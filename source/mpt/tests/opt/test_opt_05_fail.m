function test_opt_05_fail
%
% opt constructor test
% 
% 

% parametric QP with not positive semidefinite H

Opt('pF',[1 2;3 -4],'lb',[-1;-90],'f',[-1 2],'H',sparse([-1 0;0 1]));