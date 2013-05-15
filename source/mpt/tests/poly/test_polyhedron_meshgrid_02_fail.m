function test_polyhedron_meshgrid_02_fail
%
% unbounded polyhedron
%

P=Polyhedron('lb',[0;0;0]);

P.meshGrid;

end