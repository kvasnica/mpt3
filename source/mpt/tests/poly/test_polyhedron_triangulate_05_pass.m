function test_polyhedron_triangulate_05_pass
% triangulation of a polytope with attached functions

P = Polyhedron('lb', -1, 'ub', 1);
P.addFunction(AffFunction(1, 1), 'f1');
P.addFunction(AffFunction(1, 1), 'f2');

T = P.triangulate;
for i = 1:length(T)
	assert(T(i).hasFunction('f1'));
	assert(T(i).hasFunction('f2'));
end
