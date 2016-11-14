function test_ltisystem_invset_01_pass
% empty invariant set due to dynamics

sys = LTISystem('A', 1, 'f', 3);
sys.x.min = -1;
sys.x.max = 1;

S = sys.invariantSet();
assert(isa(S, 'Polyhedron'));
assert(S.Dim==1);
assert(S.isEmptySet());

end
