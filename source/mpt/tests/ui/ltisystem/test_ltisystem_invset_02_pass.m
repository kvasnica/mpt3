function test_ltisystem_invset_02_pass
% allow state constraints to be empty sets

sys = LTISystem('A', 1, 'f', 0);
sys.x.min = -1;
sys.x.max = 1;

S = sys.invariantSet('X', Polyhedron.emptySet(1));
assert(isa(S, 'Polyhedron'));
assert(S.Dim==1);
assert(S.isEmptySet());

end

