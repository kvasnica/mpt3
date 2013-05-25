function test_function_aff_09_pass
%
% objective function 
%

load data_test_qp05
A=AffFunction(p.H,p.f(:));
A.feval(p.x0);

% "x" must be a column vector
[~, msg] = run_in_caller('A.feval(p.x0'')');
asserterrmsg(msg, 'The input must be a 30x1 vector.');

end
