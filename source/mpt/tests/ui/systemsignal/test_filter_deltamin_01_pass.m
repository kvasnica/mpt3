function test_filter_deltamin_01_pass

s = SystemSignal(2);

% no deltaMin filter by default
assert(~s.hasFilter('deltaMin'));

% now add the filter
s.with('deltaMin');
assert(s.hasFilter('deltaMin'));

% value must be a vector
z = [1; 2; 3];
[~, msg] = run_in_caller('s.deltaMin=z');
asserterrmsg(msg, 'The value of deltaMin must be a 2x1 vector.');
z = [1 2];
[~, msg] = run_in_caller('s.deltaMin=z');
asserterrmsg(msg, 'The value of deltaMin must be a 2x1 vector.');
z = 'bogus';
[~, msg] = run_in_caller('s.deltaMin=z');
asserterrmsg(msg, 'The value of deltaMin must be a 2x1 vector.');

% lower bound cannot exceed upper bound
s.with('deltaMax');
s.deltaMax = [1; 1];
z = 2*s.deltaMax;
[~, msg] = run_in_caller('s.deltaMin=z');
asserterrmsg(msg, 'Lower bound cannot exceed upper bound.');

% delta-filters must introduce "previous" only for non-state signals
s = SystemSignal(1); s.setKind('u');
s.with('deltaMin');
assert(s.hasFilter('previous'));

s = SystemSignal(1); s.setKind('x');
s.with('deltaMin');
assert(~s.hasFilter('previous'));

end
