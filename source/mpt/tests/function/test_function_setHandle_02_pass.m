function test_function_setHandle_02_pass
%
% handle to nonempty function
%

F = Function(@(x) abs(x));
F.setHandle(@(x)sqrt(x.^2));

if F.isEmptyFunction
    error('object should not be empty');
end

end