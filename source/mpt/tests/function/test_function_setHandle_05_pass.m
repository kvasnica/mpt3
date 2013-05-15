function test_function_setHandle_05_pass
%
% 2 function handles
%

F(2) = Function;
F.setHandle({@(x)x,@(x)x^2});


end