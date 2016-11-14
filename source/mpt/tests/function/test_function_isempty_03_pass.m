function test_function_isempty_03_pass
%
% not empty function and empty function
%

F(3,1) = Function;
F(1).setHandle(@(x)x+1);
F(2).setHandle(@(x)x-1);

if F(1).isEmptyFunction || F(2).isEmptyFunction || ~F(3).isEmptyFunction
    error('Empty problem.');
end


end