function test_filter_soft_01_pass
% SystemSignal.softMax.maximalViolation must have correct dimension

n = 2;
s = SystemSignal(n);
assert(numel(s.max)==n);
assert(numel(s.min)==n);

s.with('softMax');
assert(numel(s.softMax.maximalViolation)==n);
assert(isequal(size(s.softMax.penalty.Q), [1 n]));
assert(s.softMax.penalty.norm==0);

s.with('softMin');
assert(numel(s.softMin.maximalViolation)==n);
assert(isequal(size(s.softMin.penalty.Q), [1 n]));
assert(s.softMin.penalty.norm==0);

end
