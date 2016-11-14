function test_polyhedron_plot_01_pass
%
% does not plot R
%


P = ExamplePoly.randVrep('d',3);

R = Polyhedron('V',P.V,'R',P.R,'lb',[-10;-5;-7],'ub',[8;7;9]);

h=plot(R);

if isempty(h)
    error('Should plot h.');
end

close all
end