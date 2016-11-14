function test_polyhedron_plot_15_pass
% plot() must respect subplot (issue #121)

% single polyhedra
close all
subplot(2, 1, 1); plot(Polyhedron.unitBox(2));
subplot(2, 1, 2); plot(Polyhedron.unitBox(3));
% two subplots must be generated
assert(numel(get(gcf, 'Children'))==2);
close all

% multiple polyhedra
close all
T1 = triangulate(Polyhedron.unitBox(2));
T2 = triangulate(Polyhedron.unitBox(3));
assert(isa(T1, 'Polyhedron'));
assert(isa(T2, 'Polyhedron'));
subplot(1, 2, 1); plot(T1);
subplot(1, 2, 2); plot(T2);
% two subplots must be generated
assert(numel(get(gcf, 'Children'))==2);
close all

end
