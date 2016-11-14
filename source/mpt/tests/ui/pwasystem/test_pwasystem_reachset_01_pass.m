function test_pwasystem_reachset_01_pass
% tests PWASystem/reachableSet (forwards)

opt_sincos;
S = sysStruct;
L1 = LTISystem('A', S.A{1}, 'B', S.B{1}, 'C', S.C{1}, 'D', S.D{1});
L1.setDomain('x', Polyhedron('A', S.guardX{1}, 'b', S.guardC{1}));
L2 = LTISystem('A', S.A{2}, 'B', S.B{2}, 'C', S.C{2}, 'D', S.D{2});
L2.setDomain('x', Polyhedron('A', S.guardX{2}, 'b', S.guardC{2}));
L = PWASystem([L1 L2]);

X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
U = Polyhedron('lb', -1, 'ub', 1);
S = L.reachableSet('X', X, 'U', U); % no direction = forwards
H1good = [1 0 1.09282032302755;0.5 -0.866025403784438 1.66602540378444;-1 0 1.09282032302755;-0.866025403784439 -0.5 1.3;0.866025403784439 0.5 1.3;-0.5 0.866025403784438 1.66602540378444];
H2good = [1 0 1.09282032302755;0.866025403784439 -0.5 1.3;-1 0 1.09282032302755;-0.5 -0.866025403784438 1.66602540378444;-0.866025403784439 0.5 1.3;0.5 0.866025403784438 1.66602540378444];
assert(S(1)==Polyhedron('H', H1good));
assert(S(2)==Polyhedron('H', H2good));

% no merging
[S, Q] = L.reachableSet('X', X, 'U', U, 'N', 3, 'direction', 'for', 'merge', false);
assert(numel(S)==8);
assert(numel(Q)==3);
assert(numel(Q{1})==2);
assert(numel(Q{2})==4);
assert(numel(Q{3})==8);
% Hgood{1}=[-1 0 1.247077;-0.5 -0.866025 1.558846;-0.5 0.866025 1.863687;0 1 2.232;0.5 -0.866025 0.866025;0.5 0.866025 2.258251;1 0 1.392225];
% Hgood{2}=[-1 0 1.392225;-0.5 -0.866025 0.866025;-0.5 0.866025 2.625102;0.5 0.866025 1.932282;1 0 0.69282];
% Hgood{3}=[-1 0 0.69282;-0.5 0.866025 1.932282;0.5 -0.866025 0.866025;0.866025 0.5 2.132;1 0 1.136225];
% Hgood{4}=[-1 0 1.136225;-0.5 -0.866025 0.866025;-0.5 0.866025 2.002251;0.5 -0.866025 1.558846;0.5 0.866025 1.420282;1 0 1.247077];
% Hgood{5}=[-1 0 1.247077;-0.5 -0.866025 1.558846;-0.5 0.866025 1.420282;0.5 -0.866025 0.866025;0.5 0.866025 2.002251;1 0 1.136225];
% Hgood{6}=[-1 0 1.136225;-0.866025 0.5 2.132;-0.5 -0.866025 0.866025;0.5 0.866025 1.932282;1 -0 0.69282];
% Hgood{7}=[-1 0 0.69282;-0.5 0.866025 1.932282;0.5 -0.866025 0.866025;0.5 0.866025 2.625102;1 0 1.392225];
% Hgood{8}=[-1 0 1.392225;-0.5 -0.866025 0.866025;-0.5 0.866025 2.258251;-0 1 2.232;0.5 -0.866025 1.558846;0.5 0.866025 1.863687;1 0 1.247077];
% Pgood = [];
% for i = 1:numel(Hgood)
% 	Pgood = [Pgood; Polyhedron('H', Hgood{i})];
% end
% Sidx = [];
% for i = 1:numel(S)
% 	idx = [];
% 	for j = 1:numel(Pgood)
% 		idx(j) = S(i)==Pgood(j);
% 	end
% 	assert(nnz(idx)==1);
% 	Sidx(i) = find(nnz(idx));
% end
% assert(nnz(Sidx)==numel(S));

% with merging
S2 = L.reachableSet('X', X, 'U', U, 'N', 3, 'direction', 'for');
assert(numel(S2)==8);
assert(isEmptySet(S\S2));
assert(isEmptySet(S2\S));


end
