function test_polyhedron_contains_27_pass
%
% P an array, x single/multiple points

P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', 0, 'ub', 2);
P = [P1 P2];

% single point in none
x = -10;
t = P.contains(x);
assert(isequal(size(t), [numel(P), size(x, 2)]));
assert(all(t==false));

% single point in P1
x = -1;
t = P.contains(x);
assert(isequal(size(t), [numel(P), size(x, 2)]));
assert(isequal(t, [true; false]));

% single point in P2
x = 2;
t = P.contains(x);
assert(isequal(size(t), [numel(P), size(x, 2)]));
assert(isequal(t, [false; true]));

% single point in both
x = 0;
t = P.contains(x);
assert(isequal(size(t), [numel(P), size(x, 2)]));
assert(isequal(t, [true; true]));

% x1 in P2, x2 in none, x3 in P1 and P2, x4 in P2
x1 = 2;
x2 = -10;
x3 = 0.1;
x4 = 1.5;
x = [x1 x2 x3 x4];
t = P.contains(x);
assert(isequal(size(t), [numel(P), size(x, 2)]));
assert(isequal(t, [false false true false; true false true true]));

end
