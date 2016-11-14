function test_pwasystem_reachset_06_pass
% PWASystem/reachableSet with empty targets

nx = 6;
nu = 3;
m1 = LTISystem('A', randn(nx), 'B', randn(nx, nu));
m2 = LTISystem('A', randn(nx), 'B', randn(nx, nu));
p = PWASystem([m1, m2]);
p.u.min = -1*ones(nu, 1);
p.u.max = 1*ones(nu, 1);

% single empty target -> reach set is empty
X = Polyhedron.emptySet(nx);
S = p.reachableSet('X', X);
assert(isa(S, 'Polyhedron'));
assert(numel(S)==1);
assert(S.Dim==6);

X = [Polyhedron.emptySet(nx), Polyhedron.emptySet(nx), Polyhedron.unitBox(nx)];
S = p.reachableSet('X', X)
assert(isa(S, 'Polyhedron'));
assert(numel(S)==2);
assert(isequal([S.Dim], [6 6]));

end
