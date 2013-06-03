function test_filter_deltaPenalty_01_pass

s = SystemSignal(2);

% the filter must automatically introduce the "previous" filter
s.with('deltaPenalty');
assert(s.hasFilter('previous'));
assert(s.hasFilter('deltaPenalty'));

% adding the filter twice must not trigger a warning about adding
% previous twice
msg=evalc('s.with(''deltaPenalty'')');
asserterrmsg(msg, 'Warning: Filter "deltaPenalty" is already present.');
assert(isempty(strfind(msg, 'Warning: Filter "previous" is already present.')));

% removing the filter must also remove previous
s.without('deltaPenalty');
assert(~s.hasFilter('previous'));
assert(~s.hasFilter('deltaPenalty'));

% delta-filters must introduce "previous" only for non-state signals
s = SystemSignal(1); s.setKind('u');
s.with('deltaPenalty');
assert(s.hasFilter('previous'));

s = SystemSignal(1); s.setKind('x');
s.with('deltaPenalty');
assert(~s.hasFilter('previous'));

end
