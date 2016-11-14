function test_polyhedron_plot_08_pass
% test plotting of multiple objects in a single plot() call

P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P2 = Polyhedron('lb', [1; 1], 'ub', [2; 2]);
P3 = Polyhedron('lb', [-1; 1], 'ub', [1; 2]);
P4 = Polyhedron('lb', [1; -1], 'ub', [2; 1]);
E = Polyhedron;

close all
h = plot(P1, P2);
assert(length(h)==2);

close all
h = plot(P1, P2, P3, P4);
assert(length(h)==4);

close all
h = plot(P1, 'color', 'b', P2, 'color', 'y');
assert(length(h)==2);

close all
h = plot(P1, 'color', 'b', P3, P2, 'color', 'y');
assert(length(h)==3);

close all
h = plot(P1, 'color', 'b', 'alpha', 0.1, P2, 'color', 'y');
assert(length(h)==2);

close all
h = plot(P1, 'color', 'b', P2, 'color', 'y', 'alpha', 0.1);
assert(length(h)==2);

close all
h = plot(E, P1); % P1 must be plotted despite E being empty
assert(length(h)==1);

close all
h = plot(E, 'linestyle', '-.', 'color', 'r', P1); % P1 must be plotted despite E being empty
assert(length(h)==1);

close all
h = plot(E, P1, 'linestyle', '-.', 'color', 'g'); % P1 must be plotted despite E being empty
assert(length(h)==1);

close all
h = plot(P2, E, P1); % P1, P2 must be plotted despite E being empty
assert(length(h)==2);

close all
end
