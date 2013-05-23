function test_polyhedron_fplot_03_pass
%
% nonlinear function
%

P = Polyhedron('lb', -2*pi, 'ub', 2*pi);
P.addFunction(@(x) sin(x), 'f');
P.fplot();
P.fplot('grid', 40);

end
