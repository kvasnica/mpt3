function test_bintreeunion_01_pass
% basic tests

P = Polyhedron('lb', -1, 'ub', 1);

% input must be a polyunion
U = Union; U.add(P);
[~, msg] = run_in_caller('BinTreePolyUnion(U)');
asserterrmsg(msg, 'Input must be a single PolyUnion object.');

% input must be a polyunion
U = Union(P);
[~, msg] = run_in_caller('BinTreePolyUnion(U)');
asserterrmsg(msg, 'Input must be a single PolyUnion object.');

% input must be a single polyunion
U1 = PolyUnion(P); U2 = PolyUnion(P);
[~, msg] = run_in_caller('BinTreePolyUnion([U1 U2])');
asserterrmsg(msg, 'Input must be a single PolyUnion object.');

% all sets must be fully dimensional
Q = Polyhedron(1);
U = PolyUnion([P Q]);
[~, msg] = run_in_caller('BinTreePolyUnion(U)');
asserterrmsg(msg, 'All sets must be fully dimensional.');

% wrong dimension of "x" in BinTreePolyUnion.contains()
T = BinTreePolyUnion(PolyUnion(P));
x = [2; 1];
[~, msg] = run_in_caller('T.contains(x)');
asserterrmsg(msg, 'The point must be a 1x1 vector.');

% test display
out = evalc('T');
asserterrmsg(out, 'PolyUnion in the dimension 1 with 1 polyhedra.');
asserterrmsg(out, 'Functions : none');
asserterrmsg(out, 'Memory-optimized binary tree, depth: 1, no. of nodes: 1');

end
