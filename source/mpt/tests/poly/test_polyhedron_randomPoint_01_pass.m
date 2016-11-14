function test_polyhedron_randomPoint_01_pass
% tests Polyhedron/randomPoint with invalid inputs

% unbounded polytopes not supported
P = Polyhedron(1, 1);
[~, msg] = run_in_caller('x = P.randomPoint();');
asserterrmsg(msg, 'The polyhedron must be bounded.');

% arrays not supported
Q = Polyhedron(2);
Z = [P, Q];
[~, msg] = run_in_caller('x = Z.randomPoint();');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

end