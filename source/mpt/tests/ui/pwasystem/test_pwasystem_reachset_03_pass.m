function test_pwasystem_reachset_03_pass
% tests PWASystem/reachableSet (backwards)

opt_sincos;
S = sysStruct;
nx = 2; nu = 1; ny = 2;
L1 = LTISystem('A', S.A{1}, 'B', S.B{1}, 'C', S.C{1}, 'D', S.D{1});
L1.setDomain('x', Polyhedron('A', S.guardX{1}, 'b', S.guardC{1}));
L2 = LTISystem('A', S.A{2}, 'B', S.B{2}, 'C', S.C{2}, 'D', S.D{2});
L2.setDomain('x', Polyhedron('A', S.guardX{2}, 'b', S.guardC{2}));
L = PWASystem([L1 L2]);

X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
U = Polyhedron('lb', -1, 'ub', 1);
S = L.reachableSet('X', X, 'U', U, 'direction', 'back');
H1good = [-0.866025403784439 0.5 2.5;1 0 0;-0.5 -0.866025403784439 1.25;0.5 0.866025403784439 1.25];
H2good = [0.866025403784439 0.5 2.5;-1 0 0;-0.5 0.866025403784439 1.25;0.5 -0.866025403784439 1.25];
assert(S(1) == Polyhedron('H', H1good));
assert(S(2) == Polyhedron('H', H2good));

% no merging
[S, Q] = L.reachableSet('X', X, 'U', U, 'N', 3, 'direction', 'back', 'merge', false);
assert(numel(S)==8);
assert(numel(Q)==3);
assert(numel(Q{1})==2);
assert(numel(Q{2})==4);
assert(numel(Q{3})==8);

end
