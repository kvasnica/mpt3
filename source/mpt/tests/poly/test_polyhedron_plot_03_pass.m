function test_polyhedron_plot_03_pass
%
% plot array of polyhedra
%


P(1) = ExamplePoly.randVrep('d',3,'nr',1);
P(2) = ExamplePoly.randHrep('d',2,'ne',1);

h=plot(P);

if isempty(h)
    error('Should plot P.');
end
if numel(h)~=5
    error('Here should be 5 handles.');
end

close all
end