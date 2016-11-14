function test_function_quad_09_pass
%
% objective function 
%

load data_test_qp05
Q=QuadFunction(p.H,p.f);

Q.feval(p.x0);

% "x" must be a column vector
[~, msg] = run_in_caller('Q.feval(p.x0'')');
asserterrmsg(msg, 'The input must be a 30x1 vector.');

end
