function test_union_hasfunction_02_pass
%
% querying multiple functions

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

% single union (must return a column vector
s = U1.hasFunction({'f', 'g'});
assert(isequal(s, [true; true]));
s = U1.hasFunction({'h', 'g'});
assert(isequal(s, [false; true]));

% arrays (must return a matrix)
s = U.hasFunction({'f', 'g'});
assert(isequal(s, [true false; true true]));

s = U.hasFunction({'h', 'g'});
assert(isequal(s, [false false; true true]));

s = U.hasFunction({'a', 'b', 'c', 'a'});
assert(isequal(s, logical([0 0 0 0; 1 0 0 1]')));

% empty arrays
Q = U([]);
s = Q.hasFunction({'f', 'v'});
assert(isempty(s));

Q = [Union Union];
s = Q.hasFunction({'f', 'g', 'c'});
assert(isequal(s, [false false; false false; false false]));

end
