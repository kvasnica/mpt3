function test_ltisystem_reachset_06_pass
% allow state constraints to be an empty set (issue #109)

sys = LTISystem('A', 1, 'f', 3);
sys.x.min = -1;
sys.x.max = 1;
X = Polyhedron.emptySet(1);

R = sys.reachableSet('direction', 'backward', 'X', X);
assert(isa(R, 'Polyhedron'));
assert(R.Dim==1);
assert(R.isEmptySet());

R = sys.reachableSet('direction', 'forward', 'X', X);
assert(isa(R, 'Polyhedron'));
assert(R.Dim==1);
assert(R.isEmptySet());

end
