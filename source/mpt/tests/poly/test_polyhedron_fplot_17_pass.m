function test_polyhedron_fplot_17_pass
% reject bogus cases

P = Polyhedron('lb', -1, 'ub', 1);
P1 = Polyhedron('lb', -1, 'ub', 1);
P1.addFunction(@(x) x, 'f');
P2 = Polyhedron('lb', -1, 'ub', 1);
P2.addFunction(@(x) x, 'g');
Q = [P1 P2];

% the object must have at least one function
[worked, msg] = run_in_caller('P.fplot()');
assert(~worked);
asserterrmsg(msg, 'The object has no functions.');

% the function name must be a string
[worked, msg] = run_in_caller('P.fplot(1)');
assert(~worked);
asserterrmsg(msg, 'The function name must be a string.');

% the function must exist
[worked, msg] = run_in_caller('P.fplot(''bogus'')');
assert(~worked);
asserterrmsg(msg, 'No such function "bogus" in the object.');

% arrays: all elements must have the function
[worked, msg] = run_in_caller('Q.fplot()');
assert(~worked);
asserterrmsg(msg, 'No such function "f" in set 2.');

% arrays: all elements must have the function
[worked, msg] = run_in_caller('Q.fplot(''f'')');
assert(~worked);
asserterrmsg(msg, 'No such function "f" in the object.');

% arrays: all elements must have the function
[worked, msg] = run_in_caller('Q.fplot(''g'')');
assert(~worked);
asserterrmsg(msg, 'No such function "g" in the object.');

% % unrecognized options must be rejected
% [worked, msg] = run_in_caller('P1.fplot(''bogus'', 1)');
% assert(~worked);
% asserterrmsg(msg, 'Argument ''bogus'' did not match any valid parameter of the parser.');

% % unrecognized options must be rejected
% [worked, msg] = run_in_caller('P1.fplot(''f'', ''bogus'', 1)');
% assert(~worked);
% asserterrmsg(msg, 'Argument ''bogus'' did not match any valid parameter of the parser.');

% the position index must be <= 2
Z = Polyhedron('lb', -1, 'ub', 1);
Z.addFunction(AffFunction([2; 1]), 'f');
[worked, msg] = run_in_caller('Z.fplot(''position'', 3)');
assert(~worked);
asserterrmsg(msg, 'The position index must be less than 3.')

% can only plot over 1D and 2D sets
Z3 = Polyhedron('lb', [-1; -1; -1], 'ub', [1; 1; 1]);
Z3.addFunction(@(x) x, 'f');
Z1 = Polyhedron('lb', -1, 'ub', 1);
Z1.addFunction(@(x) x, 'f');
Z = [Z1 Z3];
[worked, msg] = run_in_caller('Z.fplot()');
assert(~worked);
asserterrmsg(msg, 'Can only plot functions over 2D sets.')

% all polyhedra must be bounded
Z = Polyhedron('lb', -1);
Z.addFunction(@(x) x, 'f');
[worked, msg] = run_in_caller('Z.fplot()');
assert(~worked);
asserterrmsg(msg, 'Can only plot bounded polyhedra.')

% arrays: all polyhedra must be bounded
Z1 = Polyhedron('lb', -1, 'ub', 1);
Z1.addFunction(@(x) x, 'f');
Z2 = Polyhedron('lb', -1);
Z2.addFunction(@(x) x, 'f');
Z = [Z1 Z2];
[worked, msg] = run_in_caller('Z.fplot()');
assert(~worked);
asserterrmsg(msg, 'Can only plot bounded polyhedra.')

% all polyhedra must not be empty
Z = Polyhedron([1; -1], [-1; 0]);
Z.addFunction(@(x) x, 'f');
[worked, msg] = run_in_caller('Z.fplot()');
assert(~worked);
asserterrmsg(msg, 'Cannot plot function over empty sets.')

% arrays: all polyhedra must be bounded
Z1 = Polyhedron([1; -1], [-1; 0]);
Z1.addFunction(@(x) x, 'f');
Z2 = Polyhedron('lb', -1, 'ub', 1);
Z2.addFunction(@(x) x, 'f');
Z = [Z1 Z2];
[worked, msg] = run_in_caller('Z.fplot()');
assert(~worked);
asserterrmsg(msg, 'Cannot plot function over empty sets.')

end
