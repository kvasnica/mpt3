function test_polyhedron_fplot_15_pass
% tests Polyhedron/fplot('colororder')

Q1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q1.addFunction(AffFunction([1 0], 0), 'a');
Q2 = Polyhedron([eye(2); -eye(2)], [1; 2; 3; 4]);
Q2.addFunction(AffFunction([-1 0], 1), 'a');
P = [Q1 Q2];

% default colororder
P.fplot; close all;
% colororder='fixed'
P.fplot('a', 1, 'colororder', 'fixed'); close all;
% colororder='random'
P.fplot('a', 1, 'colororder', 'random'); close all;
% colororder+colormap
P.fplot('a', 1, 'colororder', 'fixed', 'colormap', hsv(10)); close all;
% colororder+colormap
P.fplot('a', 1, 'colororder', 'random', 'colormap', hsv(1)); close all;
% colororder+colormap
P.fplot('a', 1, 'colororder', 'random', 'colormap', 'mpt'); close all;
% wrong colororder
[worked, msg] = run_in_caller('P.fplot(''a'', 1, ''colororder'', ''wrong'');');
assert(~worked);
assert(~isempty(strfind(msg, 'Argument ''colororder'' failed validation')));
close all

end
