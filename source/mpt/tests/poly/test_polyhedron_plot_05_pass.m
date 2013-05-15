function test_polyhedron_plot_05_pass
%
% affine set
%


P(1) = Polyhedron('He',randn(2,3));
P(2) = Polyhedron('R',[0;0;1]);

h=plot(P,'color','blue','polyhedron',true,'linewidth',2);

if isempty(h)
    error('Should plot P.');
end
if numel(h)~=3
    error('Here should be 3 handles.');
end

close all
end