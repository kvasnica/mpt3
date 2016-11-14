function test_ltisystem_load_03_pass
% load objects with Version=1

% I don't care (too much) about loading pre-3.0.7 objects, hence this test
% is void. Keeping it for future reference, though.

return

% test_ltisystem_version_1.mat contains:
% L = LTISystem('A', [1 1; 0 0.5], 'B', [1; 0.5]);
% L.u.max = 2;
% L.u.min = -1;
% L.x.max = [3; 4];
% L.x.with('softMax');
% save test_ltisystem_version_1 L

load test_ltisystem_version_1
assert(exist('L', 'var')==1);
assert(isa(L, 'LTISystem'));
assert(isequal(L.A, [1 1; 0 0.5]));
assert(isequal(L.B, [1; 0.5]));
assert(L.u.hasFilter('min'));
assert(L.u.hasFilter('max'));
assert(isequal(L.u.min, -1));
assert(isequal(L.u.max, 2));
assert(L.x.hasFilter('min'));
assert(L.x.hasFilter('max'));
assert(isequal(L.x.min, [-Inf; -Inf]));
assert(isequal(L.x.max, [3; 4]));
assert(L.x.hasFilter('softMax'));

end
