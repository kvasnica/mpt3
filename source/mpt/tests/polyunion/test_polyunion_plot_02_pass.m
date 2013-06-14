function test_polyunion_plot_02_pass
% plotting of multiple polyunions at once

P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P2 = Polyhedron('lb', [2; 2], 'ub', [3; 3]);
P3 = Polyhedron('lb', [3; 3], 'ub', [4; 4]);
U1 = PolyUnion(P1);
U2 = PolyUnion([P2 P3]);

h=plot(U1, U2);
assert(length(h)==3);

h=plot(U1, 'color', 'b', U2, 'alpha', 0.1);
assert(length(h)==3);

h=plot(U1, 'color', 'b', U2, 'alpha', 0.1, U1, 'color', 'm', 'alpha', 1);
assert(length(h)==4);

close

end
