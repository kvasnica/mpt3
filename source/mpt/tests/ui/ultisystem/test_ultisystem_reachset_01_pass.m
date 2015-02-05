function test_ultisystem_reachset_01_pass
% tests ULTISystem/reachableSet with invalid inputs

sys = ULTISystem('A', 1, 'B', 1);

% invalid dimension of X
X = Polyhedron.unitBox(2);
[~, msg] = run_in_caller('sys.reachableSet(''X'', X);');
asserterrmsg(msg, '"X" must be in 1D.');

% X is not a polyhedron
[~, msg] = run_in_caller('sys.reachableSet(''X'', 1);');
asserterrmsg(msg, 'Argument ''X'' failed validation with error', ...
    'The value of ''X'' is invalid.');

% X must be a single polyhedron
X = [Polyhedron.unitBox(1), Polyhedron.unitBox(1)];
[~, msg] = run_in_caller('sys.reachableSet(''X'', X);');
asserterrmsg(msg, '"X" must be a single polyhedron.');

% D must be a single polyhedron
D = [Polyhedron.unitBox(1), Polyhedron.unitBox(1)];
[~, msg] = run_in_caller('sys.reachableSet(''D'', D);');
asserterrmsg(msg, '"D" must be a single polyhedron.');

% D must be a polyhedron
[~, msg] = run_in_caller('sys.reachableSet(''D'', 1);');
asserterrmsg(msg, 'The value of ''D'' is invalid.', 'Argument ''D'' failed validation with error');

% invalid dimension of D
D = Polyhedron.unitBox(2);
[~, msg] = run_in_caller('sys.reachableSet(''D'', D);');
asserterrmsg(msg, '"D" must be in 1D.');

% U must be a single polyhedron
U = [Polyhedron.unitBox(1), Polyhedron.unitBox(1)];
[~, msg] = run_in_caller('sys.reachableSet(''U'', U);');
asserterrmsg(msg, '"U" must be a single polyhedron.');

% invalid dimension of U
U = Polyhedron.unitBox(2);
[~, msg] = run_in_caller('sys.reachableSet(''U'', U);');
asserterrmsg(msg, '"U" must be in 1D.');

end
