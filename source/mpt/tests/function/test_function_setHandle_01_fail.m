function test_function_setHandle_01_fail
%
% not a function handle class
%

F = Function('Data',struct('a',1));
F.setHandle('not a handle');


end