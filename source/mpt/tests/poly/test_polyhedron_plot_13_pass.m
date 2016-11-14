function test_polyhedron_plot_13_pass
% plotting of a fancy unbounded polyhedron should work

% { (x, y, z) | |x|<=z, |y|<=z } is pointed
A = [1 0 -1; -1 0 -1; 0 1 -1; 0 -1 -1]; b = zeros(4, 1);
P = Polyhedron(A, b);
P.plot();
close all

end
