function test_filter_softmin_01_pass
% reject bogus settings

% 2D signal
n = 2;
s = SystemSignal(n);
assert(~s.hasFilter('softMin'));
s.with('softMin');
assert(s.hasFilter('softMin'));

% accept correct settings
s.softMin.maximalViolation = [10; 10];
s.softMin.penalty = OneNormFunction(eye(2));
s.softMin.penalty = InfNormFunction([1 1]);
s.softMin.penalty = AffFunction([1 1]);

% reject wrong settings
[~, msg] = run_in_caller('s.softMin.maximalViolation = 1');
asserterrmsg(msg, 'The maximal violation must be a 2x1 vector.');

[~, msg] = run_in_caller('s.softMin.maximalViolation = [1; 1; 1]');
asserterrmsg(msg, 'The maximal violation must be a 2x1 vector.');

[~, msg] = run_in_caller('s.softMin.maximalViolation = [1, 2]');
asserterrmsg(msg, 'The maximal violation must be a 2x1 vector.');

[~, msg] = run_in_caller('s.softMin.penalty = 1');
asserterrmsg(msg, 'Input must be a Function object.');

[~, msg] = run_in_caller('s.softMin.penalty = @(x) norm(x,1)');
asserterrmsg(msg, 'Input must be a Function object.');

[~, msg] = run_in_caller('s.softMin.penalty = ''norm''');
asserterrmsg(msg, 'Input must be a Function object.');

% 1D signal
n = 1;
s = SystemSignal(n);
assert(~s.hasFilter('softMin'));
s.with('softMin');
assert(s.hasFilter('softMin'));

% accept correct settings
s.softMin.maximalViolation = 2;
s.softMin.penalty = OneNormFunction(eye(n));
s.softMin.penalty = InfNormFunction(ones(n));
s.softMin.penalty = AffFunction(ones(1, n));

% reject wrong settings
[~, msg] = run_in_caller('s.softMin.maximalViolation = [1 1]');
asserterrmsg(msg, 'The maximal violation must be a 1x1 vector.');

[~, msg] = run_in_caller('s.softMin.maximalViolation = [1; 1; 1]');
asserterrmsg(msg, 'The maximal violation must be a 1x1 vector.');

[~, msg] = run_in_caller('s.softMin.penalty = 1');
asserterrmsg(msg, 'Input must be a Function object.');

[~, msg] = run_in_caller('s.softMin.penalty = @(x) norm(x,1)');
asserterrmsg(msg, 'Input must be a Function object.');

[~, msg] = run_in_caller('s.softMin.penalty = ''norm''');
asserterrmsg(msg, 'Input must be a Function object.');

end
