function test_polyunion_contains_09_pass
%
% points of incorrect dimension must be rejected

P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
U = PolyUnion(P);

% wrong dimension
x = 1;
[~, msg] = run_in_caller('t = U.contains(x)');
asserterrmsg(msg, 'The point must be a 2x1 vector.');

% wrong dimension (must be a column vector)
x = [0.1 0.1];
[~, msg] = run_in_caller('t = U.contains(x)');
asserterrmsg(msg, 'The point must be a 2x1 vector.');

% correct dimension
x = [0.1; 0.1];
assert(U.contains(x));

end
