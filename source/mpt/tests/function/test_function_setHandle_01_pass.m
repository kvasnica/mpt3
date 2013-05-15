function test_function_setHandle_01_pass
%
% handle to an empty function
%

F = Function;
F.setHandle(@(x)x);

if F.isEmptyFunction
    error('object should not be empty');
end

end