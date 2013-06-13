function test_function_aff_10_pass
%
% too many arguments
%

[worked, msg] = run_in_caller('AffFunction(1,2,3,4); ');
assert(~worked);
asserterrmsg(msg,'Too many input arguments.');

end