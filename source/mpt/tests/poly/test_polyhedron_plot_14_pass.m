function test_polyhedron_plot_14_pass
% plotting of R^n should produce an empty figure

for i = 1:3
	P = Polyhedron.fullSpace(i);
	P.plot;
end

close all

end
