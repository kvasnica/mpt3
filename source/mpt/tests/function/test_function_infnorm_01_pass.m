function test_function_infnorm_01_pass
%
% reject bad syntax and bogus cases

% weight must be provided
[~, msg] = run_in_caller('f = InfNormFunction()');
asserterrmsg(msg, 'Input argument "Q" is undefined.');

% weight must be a matrix
[~, msg] = run_in_caller('f = InfNormFunction(''a'')');
asserterrmsg(msg, 'Input argument must be a real matrix.');

% wrong dimension of "x"
f = InfNormFunction([1 1]);
[~, msg] = run_in_caller('f.Handle([1 1 1])');
asserterrmsg(msg, 'Inner matrix dimensions must agree.');

end
