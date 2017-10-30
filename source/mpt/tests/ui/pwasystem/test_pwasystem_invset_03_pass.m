function test_pwasystem_invset_03_pass
% empty invariant set due to dynamics

sys = LTISystem('A', 1, 'f', 3);
sys.x.min = -1;
sys.x.max = 1;
pwa = PWASystem([sys, sys]);
pwa.x.min = -1;
pwa.x.max = 1;

S = pwa.invariantSet();
assert(numel(S)==1);
assert(isa(S, 'Polyhedron'));
assert(S.Dim==1);
assert(all(S.isEmptySet()));

end
