function test_union_hasfunction_01_pass
%
% querying single function

f1 = @(x) x;
f2 = @(x) x^2;
f3 = @(x) x^3;
P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', 0, 'ub', 2);
P3 = Polyhedron('lb', 0.5, 'ub', 3);
P1.addFunction(f1, 'f');
P1.addFunction(f2, 'g');
P2.addFunction(f2, 'f');
P2.addFunction(f2, 'g');
P3.addFunction(f3, 'f');
P3.addFunction(f3, 'g');
U1 = PolyUnion([P1 P2 P3]);
Q1 = Polyhedron('lb', -1, 'ub', 1);
Q2 = Polyhedron('lb', 0, 'ub', 2);
Q1.addFunction(f1, 'g');
Q1.addFunction(f3, 'a');
Q2.addFunction(f2, 'g');
Q2.addFunction(f1, 'a');
U2 = PolyUnion([Q1 Q2]);
U = [U1 U2];

% single union
s = U1.hasFunction('f');
assert(s);
s = U1.hasFunction('g');
assert(s);
s = U1.hasFunction('h');
assert(~s);
s = U2.hasFunction('g');
assert(s);
s = U2.hasFunction('a');
assert(s);
s = U2.hasFunction('f');
assert(~s);

% arrays
s = U.hasFunction('f');
assert(isequal(s, [true false]));
s = U.hasFunction('g');
assert(isequal(s, [true true]));
s = U.hasFunction('another');
assert(isequal(s, [false false]));

% empty arrays
Q = U([]);
s = Q.hasFunction('f');
assert(isempty(s));

Q = [Union Union];
s = Q.hasFunction('f');
assert(isequal(s, [false false]));

end
