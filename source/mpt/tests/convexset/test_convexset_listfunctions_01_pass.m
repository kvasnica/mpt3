function test_convexset_listfunctions_01_pass
%
% must support single sets and arrays

f1 = @(x) x;
f2 = @(x) x^2;
f3 = @(x) x^3;
P1 = Polyhedron('lb', -1, 'ub', 1);
P2 = Polyhedron('lb', 0, 'ub', 2);
P3 = Polyhedron('lb', 0.5, 'ub', 3);
P1.addFunction(f1, 'f');
P1.addFunction(f2, 'ggg');
P2.addFunction(f2, 'f2');
P3.addFunction(f3, 'f');
P = [P1 P2 P3];

% single sets
L = P1.listFunctions();
assert(iscell(L));
assert(numel(L)==2);
assert(isequal(L{1}, 'f'));
assert(isequal(L{2}, 'ggg'));
L = P2.listFunctions();
assert(iscell(L));
assert(numel(L)==1);
assert(isequal(L{1}, 'f2'));

% arrays
L = P.listFunctions();
assert(iscell(L));
assert(numel(L)==3);
assert(numel(L{1})==2);
assert(isequal(L{1}{1}, 'f'));
assert(isequal(L{1}{2}, 'ggg'));
assert(numel(L{2})==1);
assert(isequal(L{2}{1}, 'f2'));
assert(numel(L{3})==1);
assert(isequal(L{3}{1}, 'f'));

% empty arrays
Q = P([]);
s = Q.listFunctions();
assert(isempty(s));

end
