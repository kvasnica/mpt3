function test_function_quad_eq_01_pass
% tests QuadFunction/eq and QuadFunction/ne

f1 = QuadFunction(1);
f2 = QuadFunction(1);
f3 = QuadFunction(2);
assert(f1==f2);
assert(f2==f1);
assert(~(f1==f3));
assert(~(f2==f3));
assert(f1~=f3);
assert(f2~=f3);

f4 = QuadFunction(1, 1);
f5 = QuadFunction(1, 1);
f6 = QuadFunction(1, 0);
assert(f1~=f4);
assert(f1==f6);
assert(f4==f5);
assert(~(f5==f6));
assert(f5~=f6);

f7 = QuadFunction(1, 1, 1);
f8 = QuadFunction(1, 1, 0);
f9 = QuadFunction(1, 1, 2);
f10 = QuadFunction(1, 1, 2);
assert(f7~=f8);
assert(f7~=f9);
assert(f9==f10);
assert(f8==f5);

f11 = QuadFunction(1, 1, 1, struct('dummy', 1));
f12 = QuadFunction(1, 1, 1, struct('dummy', 2));
f13 = QuadFunction(1, 1, 1, struct('dummy', 2));
assert(f11~=f7);
assert(~(f11==f7));
assert(f11~=f12);
assert(~(f11==f12));
assert(f12==f13);

g1 = QuadFunction(0, 1);
g2 = AffFunction(1);
assert(g1~=g2);
assert(~(g1==g2));
