function test_function_isempty_02_pass
%
% not empty function
%

F = Function(@(x)x+1,2);

if F.isEmptyFunction
    error('Must not be empty');
end


end
