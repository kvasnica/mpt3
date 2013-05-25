function test_function_aff_09_pass
%
% objective function 
%

load data_test_qp05
A=AffFunction(p.H,p.f(:));
A.feval(p.x0);
A.feval(p.x0');

end
