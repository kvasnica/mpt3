function test_function_12_pass
%
% not a function handle
%

F = Function('string');
if ~strcmp(F.Data,'string')
    error('Data stored under "Data" property do not hold.');
end

end