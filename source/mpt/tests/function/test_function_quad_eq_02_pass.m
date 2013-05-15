function test_function_quad_eq_02_pass
% QuadFunction/eq with arrays

f1 = QuadFunction(1, 0);
f2 = QuadFunction(1, 1);
f3 = QuadFunction(1, 1, 1);

status = [f1 f2 f3]==[f3 f2 f1];
assert(isequal(status, [0 1 0]));
status = [f1 f2 f3]~=[f3 f2 f1];
assert(isequal(status, [1 0 1]));

status = [f1 f2 f3]'==[f3 f2 f1]';
assert(isequal(status, [0 1 0]'));
status = [f1 f2 f3]'~=[f3 f2 f1]';
assert(isequal(status, [1 0 1]'));
