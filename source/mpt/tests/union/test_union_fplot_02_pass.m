function test_union_fplot_02_pass
% all polyhedra

P1 = Polyhedron('lb', -1, 'ub', 1); P1.addFunction(@(x) x^3, 'f');
P2 = Polyhedron('lb', 1, 'ub', 2); P2.addFunction(@(x) x^2, 'f');
P3 = Polyhedron('lb', 2, 'ub', 3); P3.addFunction(@(x) -x^2+8, 'f');
U = Union;
U.add(P1); U.add(P2); U.add(P3);
PU = Union([P1 P2 P3]);
PU2 = PolyUnion([P1 P2 P3]);

U.fplot();
PU.fplot();
PU2.fplot();

end
