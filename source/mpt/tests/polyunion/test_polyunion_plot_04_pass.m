function test_polyunion_plot_04_pass
% plot() must respect subplot (issue #121)

% single polyhedra
close all
U1 = PolyUnion(Polyhedron.unitBox(2));
U2 = PolyUnion(Polyhedron.unitBox(3));
assert(isa(U1, 'PolyUnion'));
assert(isa(U2, 'PolyUnion'));
subplot(2, 1, 1); plot(U1);
subplot(2, 1, 2); plot(U2);
% two subplots must be generated
assert(numel(get(gcf, 'Children'))==2);
close all

% multiple polyhedra
close all
U1 = PolyUnion(triangulate(Polyhedron.unitBox(2)));
U2 = PolyUnion(triangulate(Polyhedron.unitBox(3)));
assert(isa(U1, 'PolyUnion'));
assert(isa(U2, 'PolyUnion'));
subplot(1, 2, 1); plot(U1);
subplot(1, 2, 2); plot(U2);
% two subplots must be generated
assert(numel(get(gcf, 'Children'))==2);
close all

end
