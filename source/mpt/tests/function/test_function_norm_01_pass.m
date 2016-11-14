function test_function_norm_01_pass
%
% reject bad syntax and bogus cases

[~, msg] = run_in_caller('f = NormFunction(2)');
asserterrmsg(msg, 'Norm type can only be either 1 or Inf.');

[~, msg] = run_in_caller('f = NormFunction(''a'')');
asserterrmsg(msg, 'Norm type can only be either 1 or Inf.');

[~, msg] = run_in_caller('f = NormFunction(1, ''a'')');
asserterrmsg(msg, 'Input argument must be a real matrix.');

% wrong dimension of "x"
f = NormFunction(1, [1 1]);
[~, msg] = run_in_caller('f.feval([1 1])');
asserterrmsg(msg, 'Inner matrix dimensions must agree.');

end
