function test_polyhedron_fplot_18_pass
% fplot() must respect subplot (issue #121)

% single polyhedra
close all
P1 = Polyhedron.unitBox(2);
P2 = Polyhedron.unitBox(2);
P1.addFunction(QuadFunction(eye(2)), 'x');
P2.addFunction(AffFunction([1 1]), 'x');
subplot(2, 1, 1); P1.fplot();
subplot(2, 1, 2); P2.fplot();
% two subplots must be generated
assert(numel(get(gcf, 'Children'))==2);
close all

% multiple polyhedra
close all
T1 = triangulate(Polyhedron.unitBox(2));
T2 = triangulate(Polyhedron.unitBox(2)*2);
for i = 1:numel(T1)
    T1(i).addFunction(QuadFunction(eye(2)), 'x');
end
for i = 1:numel(T2)
    T2(i).addFunction(AffFunction([1 i]), 'x');
end
assert(isa(T1, 'Polyhedron'));
assert(isa(T2, 'Polyhedron'));
subplot(1, 2, 1); T1.fplot();
subplot(1, 2, 2); T2.fplot();
% two subplots must be generated
assert(numel(get(gcf, 'Children'))==2);
close all

end
