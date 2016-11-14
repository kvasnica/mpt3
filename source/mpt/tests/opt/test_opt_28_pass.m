function test_opt_28_pass
%
% opt constructor test
% 
% 

% parametric QP with not positive semidefinite H

[worked, msg] = run_in_caller('Opt(''pF'',[1 2;3 -4],''lb'',[-1;-90],''f'',[-1 2],''H'',sparse([-1 0;0 1]));');
assert(~worked);
asserterrmsg(msg,'Opt: Hessian is not positive semidefinite');
