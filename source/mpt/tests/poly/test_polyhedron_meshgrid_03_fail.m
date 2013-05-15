function test_polyhedron_meshgrid_03_fail
%
% wrong grid
%

P=Polyhedron('lb',[0;0;0],'ub',[1;2;3]);

% wrong grid number
[X,Y]=P.meshGrid(11.2);

end