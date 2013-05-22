function test_union_removeFunction_06_pass
% removing non-existent function should work

% no functions
P1 = Polyhedron('lb', -1, 'ub', 2);
U = Union;
U.add(P1);
[worked, msg] = run_in_caller('fun = U.removeFunction();');
assert(~worked);
asserterrmsg(msg, 'Not enough input arguments.');

% single function
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(@(x) x, 'fun');
U = Union;
U.add(P1);
[worked, msg] = run_in_caller('fun = U.removeFunction(''bogus'');');
assert(~worked);
asserterrmsg(msg, 'No such function "bogus" in the object.');

% single set, multiple functions
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(@(x) x, 'fun1');
P1.addFunction(@(x) x, 'fun2');
P1.addFunction(@(x) x, 'fun3');
U = Union;
U.add(P1);
[worked, msg] = run_in_caller('U.removeFunction({''fun2'', ''fun4''});');
assert(~worked);
asserterrmsg(msg, 'No such function "fun4" in the object.');

% multiple set, multiple identical functions
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(@(x) x, 'fun1');
P1.addFunction(@(x) x, 'fun2');
P1.addFunction(@(x) x, 'fun3');
P2 = Polyhedron('lb', -1, 'ub', 2);
P2.addFunction(@(x) x, 'fun1');
P2.addFunction(@(x) x, 'fun2');
P2.addFunction(@(x) x, 'fun3');
U = Union;
U.add([P1 P2]);
U.removeFunction('fun2');
assert(U.hasFunction('fun1'));
assert(~U.hasFunction('fun2'));
assert(U.hasFunction('fun3'));
