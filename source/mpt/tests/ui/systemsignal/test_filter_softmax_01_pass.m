function test_filter_softmax_01_pass
% reject bogus settings

n = 2;
s = SystemSignal(n);
assert(~s.hasFilter('softMax'));
s.with('softMax');
assert(s.hasFilter('softMax'));

% accept correct settings
s.softMax.maximalViolation = [10; 10];
s.softMax.penalty = OneNormFunction(eye(2));
s.softMax.penalty = InfNormFunction([1 1]);
s.softMax.penalty = AffFunction([1 1]);

% reject wrong settings
[~, msg] = run_in_caller('s.softMax.maximalViolation = 1');
asserterrmsg(msg, 'The maximal violation must be a 2x1 vector.');

[~, msg] = run_in_caller('s.softMax.maximalViolation = [1; 1; 1]');
asserterrmsg(msg, 'The maximal violation must be a 2x1 vector.');

[~, msg] = run_in_caller('s.softMax.maximalViolation = [1, 2]');
asserterrmsg(msg, 'The maximal violation must be a 2x1 vector.');

[~, msg] = run_in_caller('s.softMax.penalty = 1');
asserterrmsg(msg, 'Input must be a Function object.');

[~, msg] = run_in_caller('s.softMax.penalty = @(x) norm(x,1)');
asserterrmsg(msg, 'Input must be a Function object.');

[~, msg] = run_in_caller('s.softMax.penalty = ''norm''');
asserterrmsg(msg, 'Input must be a Function object.');

% 1D signal
n = 1;
s = SystemSignal(n);
assert(~s.hasFilter('softMax'));
s.with('softMax');
assert(s.hasFilter('softMax'));

% accept correct settings
s.softMax.maximalViolation = 2;
s.softMax.penalty = OneNormFunction(eye(n));
s.softMax.penalty = InfNormFunction(ones(n));
s.softMax.penalty = AffFunction(ones(1, n));

% reject wrong settings
[~, msg] = run_in_caller('s.softMax.maximalViolation = [1; 1]');
asserterrmsg(msg, 'The maximal violation must be a 1x1 vector.');

[~, msg] = run_in_caller('s.softMax.penalty = 1');
asserterrmsg(msg, 'Input must be a Function object.');

[~, msg] = run_in_caller('s.softMax.penalty = @(x) norm(x,1)');
asserterrmsg(msg, 'Input must be a Function object.');

[~, msg] = run_in_caller('s.softMax.penalty = ''norm''');
asserterrmsg(msg, 'Input must be a Function object.');

end
