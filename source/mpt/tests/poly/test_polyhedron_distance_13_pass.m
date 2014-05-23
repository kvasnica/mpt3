function test_polyhedron_distance_13_pass
% the first object must be a polyhedron object

Q = Polyhedron.unitBox(2);
x = [2;2];

[~, msg] = run_in_caller('distance(x, Q)');
asserterrmsg(msg, 'The first input must be a Polyhedron object.');

end
