function test_polyhedron_plot_02_pass
%
% plot V polyhedron
%


P = ExamplePoly.randVrep('d',3,'nr',1);

h=plot(P);

if isempty(h)
    error('Should plot P.');
end

close all
end