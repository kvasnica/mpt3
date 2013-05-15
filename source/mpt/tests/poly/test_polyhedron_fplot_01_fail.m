function test_polyhedron_fplot_01_fail
%
% unbounded polyhedron - square root function
%

P = Polyhedron('lb',[0;0]);
F = Function(@(x)sqrt(x));
P.addFunction(F,'sqr');

h1=P.fplot;



end