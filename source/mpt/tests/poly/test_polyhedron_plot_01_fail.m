function test_polyhedron_plot_01_fail
%
% wrong marking
%


P = Polyhedron('He',randn(2,3));

h=plot(P,'linestyle','a');


close all
end