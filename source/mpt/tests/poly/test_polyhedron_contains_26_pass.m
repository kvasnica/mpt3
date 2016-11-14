function test_polyhedron_contains_26_pass
%
% test rejection of wrong inputs

P = Polyhedron('lb', -1, 'ub', 1);

% "x" cannot be a string
x = 'a';
[~, msg] = run_in_caller('t = P.contains(x);');
asserterrmsg(msg, 'The input must be a real vector/matrix or a Polyhedron object.');

% "x" must have a correct dimension
x = [1; 1];
[~, msg] = run_in_caller('t = P.contains(x);');
asserterrmsg(msg, 'The point(s) must be 1x1 vector(s).');

% "x" must have a correct dimension (P in V-rep)
P = Polyhedron([-1; 1]);
x = [1; 1];
[~, msg] = run_in_caller('t = P.contains(x);');
asserterrmsg(msg, 'The vector/matrix "x" must have 1 rows.');

% "x" can only be a single polyhedron
x = [Polyhedron, Polyhedron];
[~, msg] = run_in_caller('t = P.contains(x);');
asserterrmsg(msg, 'Can only test containment of a single polyhedron.');

end
