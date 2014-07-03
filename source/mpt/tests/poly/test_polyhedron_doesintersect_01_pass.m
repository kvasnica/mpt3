function test_polyhedron_doesintersect_01_pass
% error checks in Polyhedron/doesIntersect()

P1 = Polyhedron.unitBox(1);
P2 = 1;
[~, msg] = run_in_caller('P1.doesIntersect(P2);');
asserterrmsg(msg, 'Both objects must be a Polyhedron.');

[~, msg] = run_in_caller('doesIntersect(P2, P1);');
asserterrmsg(msg, 'Both objects must be a Polyhedron.');

[~, msg] = run_in_caller('doesIntersect([P1 P1], P1);');
asserterrmsg(msg, 'Arrays are not supported.');

[~, msg] = run_in_caller('doesIntersect(P1, [P1 P1]);');
asserterrmsg(msg, 'Arrays are not supported.');

P2 = Polyhedron.unitBox(2);
[~, msg] = run_in_caller('doesIntersect(P1, P2);');
asserterrmsg(msg, 'Both polyhedra must be in the same dimension.');

end
