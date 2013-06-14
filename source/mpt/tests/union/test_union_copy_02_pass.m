function test_union_copy_02_pass
% two sets with functions

P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', -1, 'ub', 1);
P1.addFunction(@(x) x, 'f');
P2.addFunction(@(x) x, 'f');
P1.addFunction(@(x) x, 'g');
P2.addFunction(@(x) x, 'g');
U = Union;
U.add(P1);
U.add(P2);
assert(U.hasFunction('f'));
assert(U.hasFunction('g'));

C = U.copy();
assert(C.Num==U.Num);
assert(C.hasFunction('f'));
assert(C.hasFunction('g'));

% modifying original must leave copy unchanged
U.removeFunction('f');
assert(~U.hasFunction('f'));
assert(U.hasFunction('g'));
assert(C.hasFunction('f'));
assert(C.hasFunction('g'));

% modifying copy must leave original unchanged
C.removeFunction('g');
assert(~C.hasFunction('g'));
assert(U.hasFunction('g'));

end
