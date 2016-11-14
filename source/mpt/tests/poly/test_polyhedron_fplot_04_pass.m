function test_polyhedron_fplot_04_pass
%
% low-dim polyhedron - square root function
%

P = Polyhedron('lb',[0;0],'ub',[5;5],'He',[0.1 -5.2 0 ]);
F = Function(@(x)sqrt(abs(x))); % prevent failing on vertices like -1e-15
P.addFunction(F,'sqr');

P.fplot();

end
