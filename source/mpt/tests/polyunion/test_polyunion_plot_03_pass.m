function test_polyunion_plot_03_pass
% array of unions

P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P2 = Polyhedron('lb', [2; 2], 'ub', [3; 3]);
U1 = PolyUnion(P1);
U2 = PolyUnion(P2);
U = [U1 U2];

h=plot(U);
assert(length(h)==2);
h=plot(U, U, 'color', 'b');
assert(length(h)==4);

close

end
