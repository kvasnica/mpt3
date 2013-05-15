function test_polyhedron_fplot_04_pass
%
% low-dim polyhedron - square root function
%

P = Polyhedron('lb',[0;0],'ub',[5;5],'He',[0.1 -5.2 0 ]);
F = Function(@(x)sqrt(x));
P.addFunction(F,'sqr');

h1=P.fplot;

if isempty(h1)
    error('Here must be handle.');
end

close;
end