function test_ultisystem_invset_01_pass
% ULTISystem/invariantSet with invalid inputs

sys = ULTISystem('A', 1, 'B', 1);

% invalid dimension of X
X = Polyhedron.unitBox(2);
[~, msg] = run_in_caller('sys.invariantSet(''X'', X);');
asserterrmsg(msg, '"X" must be in 1D');

% X must be a polyhedron
[~, msg] = run_in_caller('sys.invariantSet(''X'', 1);');
asserterrmsg(msg, 'The value of ''X'' is invalid.', 'Argument ''X'' failed validation with error');

% D must be a single polyhedron
D = [Polyhedron.unitBox(1), Polyhedron.unitBox(1)];
[~, msg] = run_in_caller('sys.invariantSet(''D'', D);');
asserterrmsg(msg, '"D" must be a single polyhedron.');

% D must be a polyhedron
[~, msg] = run_in_caller('sys.invariantSet(''D'', 1);');
asserterrmsg(msg, 'The value of ''D'' is invalid.', 'Argument ''D'' failed validation with error');

% invalid dimension of D
D = Polyhedron.unitBox(2);
[~, msg] = run_in_caller('sys.invariantSet(''D'', D);');
asserterrmsg(msg, '"D" must be in 1D.');

% U must be a polyhedron
[~, msg] = run_in_caller('sys.invariantSet(''U'', 1);');
asserterrmsg(msg, 'The value of ''U'' is invalid.', 'Argument ''U'' failed validation with error');

% U must be a single polyhedron
U = [Polyhedron.unitBox(1), Polyhedron.unitBox(1)];
[~, msg] = run_in_caller('sys.invariantSet(''U'', U);');
asserterrmsg(msg, '"U" must be a single polyhedron.');

% invalid dimension of U
U = Polyhedron.unitBox(2);
[~, msg] = run_in_caller('sys.invariantSet(''U'', U);');
asserterrmsg(msg, '"U" must be in 1D.');

end