function test_function_aff_09_pass
%
% objective function 
%

load data_test_qp05
A=AffFunction(p.H,p.f(:));

feval(A.Handle,p.x0);
feval(A.Handle,p.x0');
end
