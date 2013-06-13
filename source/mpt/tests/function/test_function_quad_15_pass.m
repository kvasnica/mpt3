function test_function_quad_15_pass
%
% bad dimension
%

[worked, msg] = run_in_caller('QuadFunction(rand(2),[1;1],0); ');
assert(~worked);
asserterrmsg(msg,'The number of rows for matrix "F" must be 1.');

end