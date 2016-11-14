function test_filter_deltamax_01_pass

s = SystemSignal(2);

% no deltaMax filter by default
assert(~s.hasFilter('deltaMax'));

% now add the filter
s.with('deltaMax');
assert(s.hasFilter('deltaMax'));

% value must be a vector
z = [1; 2; 3];
[~, msg] = run_in_caller('s.deltaMax=z');
asserterrmsg(msg, 'The value of deltaMax must be a 2x1 vector.');
z = [1 2];
[~, msg] = run_in_caller('s.deltaMax=z');
asserterrmsg(msg, 'The value of deltaMax must be a 2x1 vector.');
z = 'bogus';
[~, msg] = run_in_caller('s.deltaMax=z');
asserterrmsg(msg, 'The value of deltaMax must be a 2x1 vector.');

% lower bound cannot exceed upper bound
s.with('deltaMin');
s.deltaMin = -[1; 1];
z = 2*s.deltaMin;
[~, msg] = run_in_caller('s.deltaMax=z');
asserterrmsg(msg, 'Upper bound cannot exceed lower bound.');

% delta-filters must introduce "previous" only for non-state signals
s = SystemSignal(1); s.setKind('u');
s.with('deltaMax');
assert(s.hasFilter('previous'));

s = SystemSignal(1); s.setKind('x');
s.with('deltaMax');
assert(~s.hasFilter('previous'));

end
