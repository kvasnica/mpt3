function test_filter_previous_01_pass
% the "previous" filter must be automatically added by deltaPenalty,
% deltaMax and deltaMin filters

s = SystemSignal(1);
assert(~s.hasFilter('previous'));

s.with('deltaPenalty');
assert(s.hasFilter('previous'));
assert(s.hasFilter('deltaPenalty'));

% the "previous" filter must not be added twice
msg = evalc('s.with(''deltaMax'');');
assert(isempty(msg));
assert(s.hasFilter('deltaMax'));

% removing deltaPenalty should leave "previous" alone since "deltaMax" is
% still using it
s.without('deltaPenalty');
assert(~s.hasFilter('deltaPenalty'));
assert(s.hasFilter('previous'));

% deltaMax is the final customer of "previous", removing the former must
% also remove the latter
s.without('deltaMax');
assert(~s.hasFilter('deltaMax'));
assert(~s.hasFilter('previous'));

% delta-filters must not introduce "previous" on state signals
s = SystemSignal(1);
s.setKind('x');
s.with('deltaPenalty');
assert(s.hasFilter('deltaPenalty'));
assert(~s.hasFilter('previous'));

s.with('deltaMax');
assert(s.hasFilter('deltaMax'));
assert(~s.hasFilter('previous'));

s.with('deltaMin');
assert(s.hasFilter('deltaMin'));
assert(~s.hasFilter('previous'));

end
