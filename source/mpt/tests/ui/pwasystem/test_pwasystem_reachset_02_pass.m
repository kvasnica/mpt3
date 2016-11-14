function test_pwasystem_reachset_02_pass
% tests PWASystem/reachableSet (forwards) w/ autonomous system

opt_sincos;
S = sysStruct;
L1 = LTISystem('A', S.A{1});
L1.setDomain('x', Polyhedron('A', S.guardX{1}, 'b', S.guardC{1}));
L2 = LTISystem('A', S.A{2});
L2.setDomain('x', Polyhedron('A', S.guardX{2}, 'b', S.guardC{2}));
L = PWASystem([L1 L2]);

X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
S = L.reachableSet('X', X);
H1good = [-0.5 0.866025403784439 0.8;-0.866025403784439 -0.5 0.8;0.5 -0.866025403784439 0.8;0.866025403784439 0.5 0.8];
H2good = [-0.5 -0.866025403784439 0.8;0.866025403784439 -0.5 0.8;0.5 0.866025403784439 0.8;-0.866025403784439 0.5 0.8];
assert(S(1)==Polyhedron('H', H1good));
assert(S(2)==Polyhedron('H', H2good));

% no merging
[S, Q] = L.reachableSet('X', X, 'N', 3, 'direction', 'f', 'merge', false);
assert(numel(S)==8);
assert(numel(Q)==3);
assert(numel(Q{1})==2);
assert(numel(Q{2})==4);
assert(numel(Q{3})==8);
B = PolyUnion(S).outerApprox();
Vgood = [0.699405006737633 0.699405006737633;0.699405006737633 -0.699405006737633;-0.699405006737633 -0.699405006737633;-0.699405006737633 0.699405006737633];
assert(norm(B.V - Vgood) < 1e-10);

% with merging
S2 = L.reachableSet('X', X, 'N', 3, 'direction', 'f', 'merge', true);
assert(numel(S2)==6);
B = PolyUnion(S2).outerApprox();
assert(norm(B.V - Vgood) < 1e-10);

end
