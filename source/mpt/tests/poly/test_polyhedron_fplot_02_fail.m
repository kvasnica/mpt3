function test_polyhedron_fplot_02_fail
%
% empty polyhedron
%

P = Polyhedron('lb',[0;0],'ub',[5;5],'He',[0.1 -5.2 1 ]);
F = Function(@(x)sqrt(x));
P.addFunction(F,'sqr');

h1=P.fplot;



end