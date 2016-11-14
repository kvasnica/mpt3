function test_function_aff_eq_01_pass
% tests AffFunction/eq and AffFunction/ne

f1 = AffFunction(1, 0);
f2 = AffFunction(1, 1);
f3 = AffFunction([1 1], 1);
f4 = AffFunction(1, 0);
f5 = AffFunction([1 1], 0);
f6 = AffFunction([1 1], 1, struct('dummy', 1));
f7 = AffFunction([1 1], 1, struct('dummy', 2));
f8 = AffFunction([1 1], 1, struct('dummy', 2));

assert(f1==f4);
assert(f7==f8);
assert(~(f1==f2)); 
assert(f1~=f2);
assert(~(f1==f3));
assert(f1~=f3);
assert(~(f1==f5));
assert(f1~=f5);
assert(~(f1==f6));
assert(f1~=f6);
assert(~(f3==f5));
assert(f3~=f5);
assert(~(f3==f6));
assert(f3~=f6);
assert(~(f6==f7));
assert(f6~=f7);

% TODO: maybe we could alllow comparing AffF with QuadF that has zero
% quadratic terms
g1 = QuadFunction(0, 1);
g2 = AffFunction(1);
assert(g1~=g2);
assert(~(g1==g2));
