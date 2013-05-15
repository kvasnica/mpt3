function test_polyunion_max_02_pass
% test for PolyUnion/max with three 1D PWA functions

f = {};
f{1}.x = [0 2; 2 6; 6 7];
f{1}.y = [5 2; 2 2; 2 1];

f{2}.x = [0 1; 1 4; 4 5; 5 7];
f{2}.y = [4 4; 4 1; 1 3; 3 3];

f{3}.x = [0 3; 3 4; 4 7];
f{3}.y = [6 1; 1 2.5; 2.5 0];

PU = [];
for i = 1:length(f)
	P = [];
	for j = 1:size(f{i}.x, 1)
		Q = Polyhedron('V', f{i}.x(j, :)').minHRep();
		
		% determine parameters of local affine functions
		a = [f{i}.x(j, :)' ones(2, 1)];
		b = f{i}.y(j, :)';
		params = a\b;
		
		F = params(1);
		g = params(2);
		
		Q.addFunction(AffFunction(F, g), 'obj');
		
		P = [P Q];
	end
	PU = [PU PolyUnion('Set', P)];
end

out = PU.max(); % should pick the only function associated to the union
assert(numel(out)==1);
assert(out.Num==7);

close all
figure
hold on
colors = 'kbm';
for i = 1:length(f)
	PU(i).fplot([], [], 'color', colors(i), 'linewidth', 3);
end
out.fplot([], [], 'color', 'g', 'linestyle', ':', 'linewidth', 3);
hold off
drawnow

V = []; F = []; g = [];
for i = 1:numel(out.Set)
	out.Set(i).computeVRep();
	V = [V; sortrows(out.Set(i).V)'];
	F = [F; out.Set(i).Func{1}.F];
	g = [g; out.Set(i).Func{1}.g];
end
Vgood = [3 3.66666666666667;1.5 3;4.52941176470588 5;5 7;0 1.5;3.66666666666667 4;4 4.52941176470588];
Fgood = [0;-1;2;-6.34413156928661e-17;-1.66666666666667;1.5;-0.833333333333333];
ggood = [2;5;-7;3;6;-3.5;5.83333333333333];

assert(norm(V-Vgood)<1e-8);
assert(norm(F-Fgood)<1e-8);
assert(norm(g-ggood)<1e-8);

end
