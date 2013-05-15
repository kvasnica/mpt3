function test_polyunion_addfun_01_pass
%
% tests adding a function to all elements of the union's set

P1 = Polyhedron('lb', [-1; -1], 'ub', [0; 1]);
P2 = Polyhedron('lb', [0; -1], 'ub', [1; 1]);
U = PolyUnion([P1 P2]);
% no functions originally
assert(isempty(U.listFunctions()));
assert(isempty(P1.listFunctions()));
assert(isempty(P2.listFunctions()));

% now add a function to each element of the set
U.addFunction(@(x) x'*x, 'name');
assert(U.hasFunction('name'));
assert(P1.hasFunction('name'));
assert(P2.hasFunction('name'));
L = U.listFunctions;
assert(isequal(L{1}, 'name'));

% add a second function
U.addFunction(@(x) x, 'another');
assert(U.hasFunction('name'));
assert(P1.hasFunction('name'));
assert(P2.hasFunction('name'));
assert(U.hasFunction('another'));
assert(P1.hasFunction('another'));
assert(P2.hasFunction('another'));
L = U.listFunctions;
% function names are sorted alphabetically
assert(isequal(L{1}, 'another'));
assert(isequal(L{2}, 'name'));


% now test array of polyunions
P1 = Polyhedron('lb', [-1; -1], 'ub', [0; 1]);
P2 = Polyhedron('lb', [0; -1], 'ub', [1; 1]);
P3 = Polyhedron('lb', [-1; -1], 'ub', [0; 1]);
P4 = Polyhedron('lb', [0; -1], 'ub', [1; 1]);
U1 = PolyUnion([P1 P2 P3]);
U2 = PolyUnion(P4);
U = [U1 U2];
assert(isempty(U(1).listFunctions()));
assert(isempty(U(2).listFunctions()));
U.addFunction(@(x) x'*x, 'name');
L = U.forEach(@(x) x.hasFunction('name'));
assert(isequal(size(L), [1 2]));
assert(all(L));
assert(U(1).hasFunction('name'));
assert(U(2).hasFunction('name'));
assert(P1.hasFunction('name'));
assert(P2.hasFunction('name'));
assert(P3.hasFunction('name'));
assert(P4.hasFunction('name'));
U.addFunction(@(x) x, 'another');
L = U.forEach(@(x) x.hasFunction('another'));
assert(all(L));
