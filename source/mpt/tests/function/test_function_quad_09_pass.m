function test_function_quad_09_pass
%
% objective function 
%

load data_test_qp05
Q=QuadFunction(p.H,p.f);

Q.feval(p.x0);
Q.feval(p.x0');

end
