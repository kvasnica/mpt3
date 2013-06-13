function test_function_quad_12_pass
%
% no arguments
%

[worked, msg] = run_in_caller('QuadFunction; ');
assert(~worked);
asserterrmsg(msg,'Not enough input arguments.');

end