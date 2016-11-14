function test_function_aff_09_pass
%
% no arguments
%

[worked, msg] = run_in_caller('AffFunction; ');
assert(~worked);
asserterrmsg(msg,'Not enough input arguments.');

end