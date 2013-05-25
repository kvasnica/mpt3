function test_convexset_feval_04_pass
%
% evaluation at multiple points
%

% currently we do not allow ConvexSet/feval() to evaluate the function at
% multiple points. should we support it, use this test.

P = Polyhedron('lb', -1, 'ub', 1);
f = AffFunction(2, 3);
P.addFunction(f, 'f');
x = [0.1, 0.2, 0.3];
[worked, msg] = run_in_caller('P.feval(x)');
assert(~worked)
%asserterrmsg(msg, 'The vector (or matrix) "x" must have 1');

return


%% 1D set, scalar-valued function
P = Polyhedron('lb', -1, 'ub', 1);
f = AffFunction(2, 3);
P.addFunction(f, 'f');

% all points inside
x = [0.1, 0.2, 0.3];
[y, feasible] = P.feval(x);
assert(isequal(y, [f.feval(x(:, 1)), f.feval(x(:, 2)), f.feval(x(:, 3))]));
assert(isequal(feasible, [true true true]));

% 1st and 3rd point inside
x = [0.1, 100, 0.4];
[y, feasible] = P.feval(x);
assert(isequal(feasible, [true false true]));
assert(isequal(size(y), [1 3]));
assert(y(1)==f.feval(x(:, 1)));
assert(y(3)==f.feval(x(:, 3)));
assert(isnan(y(2)));

% 2nd point inside
x = [200, 1, 100];
[y, feasible] = P.feval(x);
assert(isequal(feasible, [false true false]));
assert(isequal(size(y), [1 3]));
assert(isnan(y(1)));
assert(isnan(y(3)));
assert(y(2)==f.feval(x(:, 2)));

% none inside
x = [200, 1000, 100];
[y, feasible] = P.feval(x);
assert(isequal(feasible, [false false false]));
assert(isequal(size(y), [1 3]));
assert(all(isnan(y)));

%% 1D set, vector-valued function
P = Polyhedron('lb', -1, 'ub', 1);
f = AffFunction([2; 2], [3; 4]);
P.addFunction(f, 'f');

% all points inside
x = [0.1, 0.2, 0.3];
[y, feasible] = P.feval(x);
assert(isequal(y, [f.feval(x(:, 1)), f.feval(x(:, 2)), f.feval(x(:, 3))]));
assert(isequal(feasible, [true true true]));

% 1st and 3rd point inside
x = [0.1, 100, 0.4];
[y, feasible] = P.feval(x);
assert(isequal(feasible, [true false true]));
assert(isequal(size(y), [2 3]));
assert(isequal(y(:, 1), f.feval(x(:, 1))));
assert(isequal(y(:, 3), f.feval(x(:, 3))));
assert(all(isnan(y(:, 2))));

% 2nd point inside
x = [200, 1, 100];
[y, feasible] = P.feval(x);
assert(isequal(feasible, [false true false]));
assert(isequal(size(y), [2 3]));
assert(all(isnan(y(:, 1))));
assert(all(isnan(y(:, 3))));
assert(isequal(y(:, 2), f.feval(x(:, 2))));

% none inside
x = [200, 1000, 100];
[y, feasible] = P.feval(x);
assert(isequal(feasible, [false false false]));
assert(isequal(size(y), [2 3]));
assert(all(isnan(y(:))));


%% 2D set, scalar-valued function
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
f = AffFunction([2 3], 4);
P.addFunction(f, 'f');

% all points inside
x = [0.1 0.1; 0.2 0.2; 0.3 0.3]';
[y, feasible] = P.feval(x);
assert(isequal(y, [f.feval(x(:, 1)), f.feval(x(:, 2)), f.feval(x(:, 3))]));
assert(isequal(feasible, [true true true]));

% 1st and 3rd point inside
x = [0.1 0.1; 200 0.2; 0.3 0.3]';
[y, feasible] = P.feval(x);
assert(isequal(feasible, [true false true]));
assert(isequal(size(y), [1 3]));
assert(isequal(y(:, 1), f.feval(x(:, 1))));
assert(isequal(y(:, 3), f.feval(x(:, 3))));
assert(all(isnan(y(:, 2))));

% 2nd point inside
x = [100 0.1; 0.2 0.2; 300 0.3]';
[y, feasible] = P.feval(x);
assert(isequal(feasible, [false true false]));
assert(isequal(size(y), [1 3]));
assert(all(isnan(y(:, 1))));
assert(all(isnan(y(:, 3))));
assert(isequal(y(:, 2), f.feval(x(:, 2))));

% none inside
x = [100 0.1; 200 0.2; 300 0.3]';
[y, feasible] = P.feval(x);
assert(isequal(feasible, [false false false]));
assert(isequal(size(y), [1 3]));
assert(all(isnan(y(:))));

%% 2D set, vector-valued function
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
f = AffFunction([2 3; 4 5; 6 7; 8 9], [3; 4; 5; 6]);
P.addFunction(f, 'f');

% all points inside
x = [0.1 0.1; 0.2 0.2; 0.3 0.3]';
[y, feasible] = P.feval(x);
assert(isequal(y, [f.feval(x(:, 1)), f.feval(x(:, 2)), f.feval(x(:, 3))]));
assert(isequal(feasible, [true true true]));

% 1st and 3rd point inside
x = [0.1 0.1; 200 0.2; 0.3 0.3]';
[y, feasible] = P.feval(x);
assert(isequal(feasible, [true false true]));
assert(isequal(size(y), [4 3]));
assert(isequal(y(:, 1), f.feval(x(:, 1))));
assert(isequal(y(:, 3), f.feval(x(:, 3))));
assert(all(isnan(y(:, 2))));

% 2nd point inside
x = [100 0.1; 0.2 0.2; 300 0.3]';
[y, feasible] = P.feval(x);
assert(isequal(feasible, [false true false]));
assert(isequal(size(y), [4 3]));
assert(all(isnan(y(:, 1))));
assert(all(isnan(y(:, 3))));
assert(isequal(y(:, 2), f.feval(x(:, 2))));

% none inside
x = [100 0.1; 200 0.2; 300 0.3]';
[y, feasible] = P.feval(x);
assert(isequal(feasible, [false false false]));
assert(isequal(size(y), [4 3]));
assert(all(isnan(y(:))));

end
