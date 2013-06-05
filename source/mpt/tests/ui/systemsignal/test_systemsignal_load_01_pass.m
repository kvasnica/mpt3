function test_systemsignal_load_01_pass
% load objects with Version=1

% I don't care (too much) about loading pre-3.0.7 objects, hence this test
% is void. Keeping it for future reference, though.

return

% file test_signal_version_1.mat contains:
%  s = SystemSignal(2);
%  s.min = [1; 2];
%  s.max = [3; 4];
%  save test_signal_version_1 s

load test_signal_version_1
assert(exist('s', 'var')==1);
assert(isa(s, 'SystemSignal'));
assert(s.hasFilter('min'));
assert(s.hasFilter('max'));
assert(isequal(s.min, [1; 2]));
assert(isequal(s.max, [3; 4]));

end
