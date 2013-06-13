function test_function_aff_11_pass
%
% bad dimension
%

[worked, msg] = run_in_caller('AffFunction(1,[]); ');
assert(~worked);
asserterrmsg(msg,'The vector "g" must be of the size 1.');

end