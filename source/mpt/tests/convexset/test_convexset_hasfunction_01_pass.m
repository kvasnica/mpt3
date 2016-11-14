function test_convexset_hasfunction_01_pass
%
% single sets and arrays, querying single function

f1 = @(x) x;
f2 = @(x) x^2;
f3 = @(x) x^3;
P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', 0, 'ub', 2);
P3 = Polyhedron('lb', 0.5, 'ub', 3);
P1.addFunction(f1, 'f');
P1.addFunction(f2, 'g');
P2.addFunction(f2, 'f2');
P3.addFunction(f3, 'f');
P = [P1 P2 P3];

% single sets
s = P1.hasFunction('f');
assert(s);
s = P1.hasFunction('f2');
assert(~s);
s = P2.hasFunction('f2');
assert(s);

% arrays
s = P.hasFunction('f');
assert(isequal(s, [true false true]));

% empty arrays
Q = P([]);
s = Q.hasFunction('f');
assert(isempty(s));

end
