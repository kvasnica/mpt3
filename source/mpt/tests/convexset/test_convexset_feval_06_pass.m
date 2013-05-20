function test_convexset_feval_06_pass
%
% evaluation of arrays

f1 = @(x) [x; 1; 3; 1];
f2 = @(x) [x^2; x; 0; 1];
f3 = @(x) [x^3; -1; 4; 1];
P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', 0, 'ub', 2);
P3 = Polyhedron('lb', 0.5, 'ub', 3);
P1.addFunction(f1, 'f');
P2.addFunction(f2, 'f');
P3.addFunction(f3, 'f');
P = [P1 P2 P3];

% point in all three sets
x = 0.8;
[fval, feasible] = P.feval(x);
assert(isequal(size(fval), [4 3]));
assert(isequal(fval, [f1(x), f2(x), f3(x)]));
assert(isequal(feasible, [true true true]));

% point in no set
x = -10;
[fval, feasible] = P.feval(x);
assert(isequal(size(fval), [4 3]));
assert(all(isnan(fval(:))));
assert(isequal(feasible, [false false false]));

% point in P2, P3
x = 1.5;
[fval, feasible] = P.feval(x);
assert(isequal(size(fval), [4 3]));
assert(all(isnan(fval(:, 1))));
assert(isequal(fval(:, 2), f2(x)));
assert(isequal(fval(:, 3), f3(x)));
assert(isequal(feasible, [false true true]));

% point in P3
x = 2.5;
[fval, feasible] = P.feval(x);
assert(isequal(size(fval), [4 3]));
assert(all(isnan(fval(:, 1))));
assert(all(isnan(fval(:, 2))));
assert(isequal(fval(:, 3), f3(x)));
assert(isequal(feasible, [false false true]));
