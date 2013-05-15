function test_pwasystem_reachset_04_pass
% tests PWASystem/reachableSet (backwards) w/ autonomous system

opt_sincos;
S = sysStruct;
nx = 2; nu = 1; ny = 2;
L1 = LTISystem('A', S.A{1});
L1.setDomain('x', Polyhedron('A', S.guardX{1}, 'b', S.guardC{1}));
L2 = LTISystem('A', S.A{2});
L2.setDomain('x', Polyhedron('A', S.guardX{2}, 'b', S.guardC{2}));
L = PWASystem([L1 L2]);

X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
[S, ~, dyn] = L.reachableSet('X', X, 'direction', 'back');
assert(isa(S, 'Polyhedron'));
assert(numel(S)==2);
assert(isequal(dyn, [1 2]));
P1 = Polyhedron('H', [-0.692820323027551 0.4 1;0.4 0.692820323027551 1;-0.4 -0.692820323027551 1;1 0 0]);
P2 = Polyhedron('H', [0.692820323027551 0.4 1;0.4 -0.692820323027551 1;-0.4 0.692820323027551 1;-1 0 0]);
assert(S(1)==P1);
assert(S(2)==P2);

% no merging
[S, Q, dyn, dynN] = L.reachableSet('X', X, 'N', 2, 'direction', 'b', 'merge', false);
assert(numel(S)==4);
assert(numel(Q)==2);
assert(numel(Q{1})==2);
assert(numel(Q{2})==4);
assert(isequal(dyn, [1 1 2 2]));

% % with merging
% [S, Q, dyn, dynN] = L.reachableSet('X', X, 'N', 2, 'direction', 'b', 'merge', true);
% assert(numel(S)==2);
% assert(numel(Q)==2);
% assert(numel(Q{1})==2);
% assert(numel(Q{2})==2);
% assert(isequal(dyn, [1 2]));

end
