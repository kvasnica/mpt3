function test_polyhedron_plot_04_pass
%
% plot array of polyhedra, different markings
%


P(1) = ExamplePoly.randVrep('d',3);
P(2) = ExamplePoly.randHrep('d',2);

h=plot(P,'wire',true,'linewidth',3,'linestyle','--');

if isempty(h)
    error('Should plot P.');
end
if numel(h)~=2
    error('Here should be 2 handles.');
end

close all
end