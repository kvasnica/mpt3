function test_polyhedron_plot_07_pass
% tests Polyhedron/plot('colororder')

Q1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q2 = Polyhedron([eye(2); -eye(2)], [1; 2; 3; 4]);
P = [Q1 Q2];

% default colororder
P.plot; close all;
% colororder='fixed'
P.plot('colororder', 'fixed'); close all;
% colororder='random'
P.plot('colororder', 'random'); close all;
% colororder+colormap
P.plot('colororder', 'fixed', 'colormap', hsv(10)); close all;
% colororder+colormap
P.plot('colororder', 'random', 'colormap', hsv(1)); close all;
% colororder+colormap
P.plot('colororder', 'random', 'colormap', 'mpt'); close all;
% wrong colororder
[worked, msg] = run_in_caller('P.plot(''colororder'', ''wrong'');');
assert(~worked);
assert(~isempty(strfind(msg, 'Argument ''colororder'' failed validation')));
close all

end
