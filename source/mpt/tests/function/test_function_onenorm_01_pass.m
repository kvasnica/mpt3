function test_function_onenorm_01_pass
%
% reject bad syntax and bogus cases

% weight must be provided
[~, msg] = run_in_caller('f = OneNormFunction()');
asserterrmsg(msg, 'Input argument "Q" is undefined.');

% weight must be a matrix
[~, msg] = run_in_caller('f = OneNormFunction(''a'')');
asserterrmsg(msg, 'Input argument must be a real matrix.');

% wrong dimension of "x"
f = OneNormFunction([1 1]);
[~, msg] = run_in_caller('f.feval([1 1 1])');
asserterrmsg(msg, 'Inner matrix dimensions must agree.');

end
