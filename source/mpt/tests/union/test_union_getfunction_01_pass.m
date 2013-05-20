function test_union_getfunction_01_pass
% sets are polyhedra

%% no functions

% function name must be specified
P1 = Polyhedron('lb', -1, 'ub', 2);
U = Union;
U.add(P1);
[~, msg] = run_in_caller('fun = U.getFunction()');
asserterrmsg(msg, 'Not enough input arguments.');

%% single function

% getting the function must not modify the original object
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(@(x) x, 'fun');
U = Union;
U.add(P1);
F = U.getFunction('fun');
assert(U.hasFunction('fun'));
assert(F.hasFunction('fun'));

% multiple sets (all polyhedra)
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(@(x) x, 'fun');
P2 = Polyhedron('lb', -1, 'ub', 2);
P2.addFunction(@(x) x, 'fun');
U = Union;
U.add(P2);
F = U.getFunction('fun');
assert(U.hasFunction('fun'));
assert(F.hasFunction('fun'));

%% multiple functions

% getting the function must not modify the original object
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(@(x) x, 'fun1');
P1.addFunction(@(x) x, 'fun2');
U = Union;
U.add(P1);
F = U.getFunction('fun2');
assert(U.hasFunction('fun1'));
assert(U.hasFunction('fun2'));
assert(F.hasFunction('fun2'));
assert(~F.hasFunction('fun1'));

% multiple sets (all polyhedra)
P1 = Polyhedron('lb', -1, 'ub', 2);
P1.addFunction(@(x) x, 'fun1');
P1.addFunction(@(x) x, 'fun2');
P2 = Polyhedron('lb', -1, 'ub', 2);
P2.addFunction(@(x) x, 'fun1');
P2.addFunction(@(x) x, 'fun2');
U = Union;
U.add(P2);
F = U.getFunction('fun2');
assert(U.hasFunction('fun1'));
assert(U.hasFunction('fun2'));
assert(F.hasFunction('fun2'));
assert(~F.hasFunction('fun1'));
