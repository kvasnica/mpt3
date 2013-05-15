function test_polyhedron_plot_09_pass
% test plotting of multiple arrays in a single plot() call

P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P2 = Polyhedron('lb', [1; 1], 'ub', [2; 2]);
P3 = Polyhedron('lb', [-1; 1], 'ub', [1; 2]);
P4 = Polyhedron('lb', [1; -1], 'ub', [2; 1]);
A1 = [P1 P2];
A2 = [P3 P4];

close all
h = plot(A1, A2);
assert(length(h)==4);

% both of A1 in red, each of A2 in different color
close all
h = plot(A1, 'color', 'r', A2);
assert(length(h)==4);

% plot individual objects along arrays (individual object first)
close all
h = plot(P2, A1, 'color', 'r', A2, P1);
assert(length(h)==6);

% plot individual objects along arrays (array first)
close all
h = plot(A1, P2, A2, P1);
assert(length(h)==6);

% both of A1 in red, both of A2 in black
close all
h = plot(A1, 'color', 'r', A2, 'alpha', 0.4, 'color', 'k');
assert(length(h)==4);

% more options
close all
h = plot(A1, 'color', 'r', 'linestyle', ':', ...
	A2, 'alpha', 0.4, 'color', 'k');
assert(length(h)==4);

close all
end
