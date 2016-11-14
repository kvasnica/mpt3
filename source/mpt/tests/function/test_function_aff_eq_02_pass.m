function test_function_aff_eq_02_pass
% AffFunction/eq with arrays

f1 = AffFunction(1, 0);
f2 = AffFunction(1, 1);
f3 = AffFunction([1 1], 1);

status = [f1 f2 f3]==[f3 f2 f1];
assert(isequal(status, [0 1 0]));
status = [f1 f2 f3]~=[f3 f2 f1];
assert(isequal(status, [1 0 1]));

status = [f1 f2 f3]'==[f3 f2 f1]';
assert(isequal(status, [0 1 0]'));
status = [f1 f2 f3]'~=[f3 f2 f1]';
assert(isequal(status, [1 0 1]'));
