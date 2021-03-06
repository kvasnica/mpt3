function test_function_setHandle_04_pass
%
% two parameters in a handle
%

F(2) = Function;

F(1).Data.a = 1;
F(2).Data.b = 2;

F(1).setHandle(@(x)F(1).Data.a*x-1);
F(2).setHandle(@(y)F(2).Data.b*y+1);

F(1).feval(1);
F(2).feval(2);

end
