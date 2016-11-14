function test_union_listFunctions_04_pass
%
% arrays of unions

f1 = @(x) x;
f2 = @(x) x^2;
f3 = @(x) x^3;
P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', 0, 'ub', 2);
P3 = Polyhedron('lb', 0.5, 'ub', 3);
P1.addFunction(f1, 'f1');
P2.addFunction(f2, 'f1');
P3.addFunction(f3, 'f1');
U1 = PolyUnion([P1 P2 P3]);
Q1 = Polyhedron('lb', -1, 'ub', 1);
Q2 = Polyhedron('lb', 0, 'ub', 2);
Q1.addFunction(f1, 'g');
Q1.addFunction(f3, 'a');
Q2.addFunction(f2, 'g');
Q2.addFunction(f1, 'a');
U2 = PolyUnion([Q1 Q2]);
U = [U1 U2];

% single unions
L = U1.listFunctions();
assert(iscell(L));
assert(numel(L)==1);
assert(isequal(L{1}, 'f1'));
L = U2.listFunctions();
assert(iscell(L));
assert(numel(L)==2);
assert(isequal(L{1}, 'a')); % sorted by containers.Map
assert(isequal(L{2}, 'g'));

% array
L = U.listFunctions();
assert(iscell(L));
assert(numel(L)==2);
assert(isequal(L{1}{1}, 'f1'));
assert(isequal(L{2}{1}, 'a')); % sorted by containers.Map
assert(isequal(L{2}{2}, 'g'));

% empty arrays
Q = U([]);
L = Q.listFunctions();
assert(iscell(L));
assert(isempty(L));

Q = [Union Union Union];
L = Q.listFunctions();
assert(iscell(L));
assert(isempty(L));

