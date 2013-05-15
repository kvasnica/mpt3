function test_polyhedron_fplot_14_pass
% tests Polyhedron/fplot with custom colormaps

% test single polyhedra as well as arrays
Q1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q1.addFunction(AffFunction([1 0], 0), 'a');
Q2 = Polyhedron([eye(2); -eye(2)], [1; 2; 3; 4]);
Q2.addFunction(AffFunction([-1 0], 1), 'a');
P{1} = Q1; P{2} = [Q1 Q2];

for i = 1:length(P)
	% default colormap
	P{i}.fplot('a'); close all;
	% default colormap
	P{i}.fplot('a', 1, 'colormap', 'mpt'); close all;
	% custom colormap identified by string
	P{i}.fplot('a', 1, 'colormap', 'hsv'); close all;
	% custom colormap identified by double
	M = hsv(10);
	P{i}.fplot('a', 1, 'colormap', M); close all;
	% wrong colormap string
	[worked, msg] = run_in_caller('P{i}.fplot(''a'', 1, ''colormap'', ''nofunction'');');
	assert(~worked);
	assert(~isempty(strfind(msg, 'Undefined function or variable ''nofunction''.')));
	close all
end

end
