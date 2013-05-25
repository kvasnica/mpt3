function test_filter_soft_01_pass
% SystemSignal.softMax.maximalViolation must have correct dimension

n = 2;
s = SystemSignal(n);
assert(numel(s.max)==n);
assert(numel(s.min)==n);

s.with('softMax');
assert(numel(s.softMax.maximalViolation)==n);
assert(isequal(size(s.softMax.penalty.weight), [1 n]));
assert(isa(s.softMax.penalty, 'AffFunction'));

s.with('softMin');
assert(numel(s.softMin.maximalViolation)==n);
assert(isequal(size(s.softMin.penalty.weight), [1 n]));
assert(isa(s.softMin.penalty, 'AffFunction'));

end
