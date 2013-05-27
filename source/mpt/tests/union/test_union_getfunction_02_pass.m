function test_union_getfunction_02_pass
% some sets are not polyhedra

% NOTE: Union/getFunction is currently broken since we have no copy()
% method for generic sets

% single function, no problems
x = sdpvar(1);
P = YSet(x, [-1 <= x <= 1]);
P.addFunction(@(z) z, 'f');
U = Union;
U.add(P);
F = U.getFunction('f');
assert(U.hasFunction('f'));
assert(F.hasFunction('f'));

% two functions, requires a proper copy behavior
x = sdpvar(1);
P = YSet(x, [-1 <= x <= 1]);
P.addFunction(@(z) z, 'f1');
P.addFunction(@(z) z, 'f2');
U = Union(P);
F = U.getFunction('f1');
assert(U.hasFunction('f1'));
assert(U.hasFunction('f2'));
assert(F.hasFunction('f1'));
assert(~F.hasFunction('f2'));

% mixed polyhedra/other sets
U = Union;
x = sdpvar(1);
P = YSet(x, [-1 <= x <= 1]);
P.addFunction(@(z) z, 'f1');
P.addFunction(@(z) z, 'f2');
U.add(P);
P = Polyhedron('lb', 0, 'ub', 1);
P.addFunction(@(z) z, 'f1');
P.addFunction(@(z) z, 'f2');
U.add(P);
F = U.getFunction('f1');
assert(U.hasFunction('f1'));
assert(U.hasFunction('f2'));
assert(F.hasFunction('f1'));
assert(~F.hasFunction('f2'));

end
