function test_pwasystem_invset_04_pass
% allow empty state constraints

sys = LTISystem('A', 1, 'f', 0);
sys.x.min = -1;
sys.x.max = 1;
pwa = PWASystem([sys, sys]);
pwa.x.min = -1;
pwa.x.max = 1;

S = pwa.invariantSet('X', Polyhedron.emptySet(1));
assert(isa(S, 'Polyhedron'));
assert(isequal([S.Dim], [1]));
assert(all(S.isEmptySet()));

end
