function test_union_getfunction_03_pass
% function must exist

% no functions
P1 = Polyhedron('lb', -1, 'ub', 2);
U = Union;
U.add(P1);
[worked, msg] = run_in_caller('fun = U.getFunction();');
assert(~worked);
asserterrmsg(msg, 'Not enough input arguments.');

% single function
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(@(x) x, 'fun');
U = Union;
U.add(P1);
[worked, msg] = run_in_caller('fun = U.getFunction(''bogus'');');
assert(~worked);
asserterrmsg(msg, 'No such function "bogus" in the object.');

% multiple functions, retrieving only those which exist
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(@(x) x, 'f1');
P1.addFunction(@(x) x, 'f2');
P1.addFunction(@(x) x, 'f3');
U = Union;
U.add(P1);
F = U.getFunction({'f1', 'f3'});
assert(isequal(U.hasFunction({'f1', 'f2', 'f3'}), [true; true; true]));
assert(isequal(F.hasFunction({'f1', 'f2', 'f3'}), [true; false; true]));

% multiple functions, trying to get a non-existent function
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(@(x) x, 'f1');
P1.addFunction(@(x) x, 'f2');
P1.addFunction(@(x) x, 'f3');
U = Union;
U.add(P1);
[worked, msg] = run_in_caller('F = U.getFunction({''f3'', ''bogus''});');
assert(~worked);
asserterrmsg(msg, 'No such function "bogus" in the object.');
