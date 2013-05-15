function test_function_11_pass
%
% not a function handle
%

F = Function(1);
if F.Data ~= 1
    error('The argument should be stored in "Data" property.');
end

end