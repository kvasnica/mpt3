function test_function_setHandle_07_pass
%
% not a function test_function_setHandle_07_pass
%

F = Function('Data',struct('a',1));
[worked, msg] = run_in_caller('F.setHandle(''not a handle''); ');
assert(~worked);
asserterrmsg(msg,'There must be 1 handles present in a cell.');


end