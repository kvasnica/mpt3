function test_function_quad_13_pass
%
% too many arguments
%

[worked, msg] = run_in_caller('QuadFunction(1,2,3,4,5); ');
assert(~worked);
asserterrmsg(msg,'Too many input arguments.');

end