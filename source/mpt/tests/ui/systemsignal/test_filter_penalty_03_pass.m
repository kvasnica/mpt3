function test_filter_penalty_03_pass
% penalty defined as a Function object

s = SystemSignal(2);

% reject function handles
[~, msg] = run_in_caller('s.penalty = @(x) x;');
asserterrmsg(msg, 'Input must be a Function object.');

% Function objects should work
s.penalty = Function(@(x) x);
assert(isa(s.penalty, 'Function'));

end
