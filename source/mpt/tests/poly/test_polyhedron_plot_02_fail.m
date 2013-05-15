function test_polyhedron_plot_02_fail
%
% wrong color
%


P = ExamplePoly.randHrep;

h=plot(P,'color','abc');


close all
end