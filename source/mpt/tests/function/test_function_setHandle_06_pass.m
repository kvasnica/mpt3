function test_function_setHandle_06_pass
%
% 3 function handles
%

F(3,1) = Function;
F.setHandle({@(x)x;@(x)x^2;@(x)x^3});


end