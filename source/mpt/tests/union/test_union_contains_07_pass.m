function test_union_contains_07_pass
%
% points of wrong dimensions must be rejected
%

x = sdpvar(1,1);
y = sdpvar(2, 1);
Y1 = YSet(x, [-1 <= x <= 1]);
Y2 = YSet(y, [0 <= y <= 2]);
P = Polyhedron('lb', [-2; -2], 'ub', [2; 2]);
Q = Polyhedron('lb', -1, 'ub', 1);

% YSets
U = Union([Y1 Y2]);
[~, msg] = run_in_caller('U.contains([0; 0]);');
asserterrmsg(msg, 'All sets must be 2-dimensional.');

% Yset and Polyhedron
U = Union;
U.add(Y1);
U.add(P);
[~, msg] = run_in_caller('U.contains([0; 0]);');
asserterrmsg(msg, 'All sets must be 2-dimensional.');

% two polyhedra
U = Union([P Q]);
[~, msg] = run_in_caller('U.contains(0);');
asserterrmsg(msg, 'All sets must be 1-dimensional.');
[~, msg] = run_in_caller('U.contains([0; 0]);');
asserterrmsg(msg, 'All sets must be 2-dimensional.');

end
