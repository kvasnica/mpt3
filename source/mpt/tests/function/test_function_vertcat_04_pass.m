function test_function_vertcat_04_pass
%
% only the same objects can concatenated
%

F = Function;
L = AffFunction(1,1);

[worked, msg] = run_in_caller('[F;L]; ');
assert(~worked);
asserterrmsg(msg,'Only the same objects can be concatenated.');

end