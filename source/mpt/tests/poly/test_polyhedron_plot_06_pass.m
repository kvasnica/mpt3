function test_polyhedron_plot_06_pass
% tests Polyhedron/plot with custom colormaps

% test single polyhedra as well as arrays
Q1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q2 = Polyhedron([eye(2); -eye(2)], [1; 2; 3; 4]);
P{1} = Q1; P{2} = [Q1 Q2];

for i = 1:length(P)
	% default colormap
	P{i}.plot; close all;
	% default colormap
	P{i}.plot('colormap', 'mpt'); close all;
	% custom colormap identified by string
	P{i}.plot('colormap', 'hsv'); close all;
	% custom colormap identified by double
	M = hsv(10);
	P{i}.plot('colormap', M); close all;
	% wrong colormap string
	[worked, msg] = run_in_caller('P{i}.plot(''colormap'', ''nofunction'');');
	assert(~worked);
	assert(~isempty(strfind(msg, 'Undefined function or variable ''nofunction''.')));
	close all
end

end
