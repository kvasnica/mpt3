function test_function_quad_14_pass
%
% bad dimension
%

[worked, msg] = run_in_caller('QuadFunction(1,[],0); ');
assert(~worked);
asserterrmsg(msg,'The number of rows for matrix "F" must be 1.');

end