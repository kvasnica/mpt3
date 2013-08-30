function test_convexset_support_08_pass
% "x" must be a matrix of column vectors

P = Polyhedron('lb', -1, 'ub', 1);
% column vector with 3 element = wrong dimension
x = [1; 2; 3];
[~, msg] = run_in_caller('P.support(x)');
asserterrmsg(msg, 'Input argument "x" must have 1 rows.');
% x=[1 2 3] means evaluation for three points
supp = P.support([1 2 3]);
assert(isequal(supp, [1; 2; 3]));

P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
x = [1; 2; 3];
[~, msg] = run_in_caller('P.support(x)');
asserterrmsg(msg, 'Input argument "x" must have 2 rows.');
x1 = [1; 2];
x2 = [3; 4];
x = [x1 x2];
supp = P.support(x);
assert(isequal(supp, [3; 7]));

x3 = [5; 6];
x = [x1 x2 x3];
supp = P.support(x);
assert(isequal(supp, [3; 7; 11]));

% wrong dimensions again:
x = [x1 x2 x3]';
[~, msg] = run_in_caller('P.support(x)');
asserterrmsg(msg, 'Input argument "x" must have 2 rows.');

end
