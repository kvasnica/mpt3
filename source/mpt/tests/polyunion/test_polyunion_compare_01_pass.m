function test_polyunion_compare_01_pass
% PolyUnion/compare must reject wrong inputs

P1 = Polyhedron.unitBox(2);
U1 = PolyUnion(P1);
U2 = PolyUnion(P1);

[~, msg] = run_in_caller('U1.compare()');
asserterrmsg(msg, 'Not enough input arguments.');

[~, msg] = run_in_caller('U1.compare(P1)');
asserterrmsg(msg, 'The second input must be a PolyUnion object.');

[~, msg] = run_in_caller('U1.compare(U2)');
asserterrmsg(msg, 'The object has no functions.');

P2 = Polyhedron.unitBox(1);
P2.addFunction(AffFunction(1, 1), 'x');
U2 = PolyUnion(P2);

[~, msg] = run_in_caller('U2.compare(U1)');
asserterrmsg(msg, 'No such function "x" in the object.');

[~, msg] = run_in_caller('U2.compare(U1, ''y'')');
asserterrmsg(msg, 'No such function "y" in the object.');

[~, msg] = run_in_caller('U2.compare([U1 U1])');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

A = [U2 U2];
[~, msg] = run_in_caller('A.compare([U1 U1])');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

% reject anything but PWA functions
P1 = Polyhedron.unitBox(1);
P1.addFunction(AffFunction(1, 1), 'x');
U1 = PolyUnion(P1);
P2 = Polyhedron.unitBox(1);
P2.addFunction(QuadFunction(1), 'x');
U2 = PolyUnion(P2);
[~, msg] = run_in_caller('U1.compare(U2)');
asserterrmsg(msg, 'Function "x" must be affine.');
[~, msg] = run_in_caller('U2.compare(U1)');
asserterrmsg(msg, 'Function "x" must be affine.');

% incompatible dimensions
P1 = Polyhedron.unitBox(1);
P1.addFunction(AffFunction(1, 1), 'x');
U1 = PolyUnion(P1);
P2 = Polyhedron.unitBox(2);
P2.addFunction(AffFunction([1 1], 1), 'x');
U2 = PolyUnion(P2);
[~, msg] = run_in_caller('U1.compare(U2)');
asserterrmsg(msg, 'The functions must be defined over the same domain.');

% incompatible domains
P2 = Polyhedron.unitBox(1)*2;
P2.addFunction(AffFunction(1, 1), 'x');
U2 = PolyUnion(P2);
[~, msg] = run_in_caller('U1.compare(U2)');
asserterrmsg(msg, 'The functions must be defined over the same domain.');


end
