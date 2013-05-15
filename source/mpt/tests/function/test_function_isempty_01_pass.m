function test_function_isempty_01_pass
%
% empty function
%

F(3,1) = Function;
if any(~F.isEmptyFunction)
    error('Must be an array of empty functions.');
end


end