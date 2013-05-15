function test_polyhedron_meshgrid_04_fail
%
% 1D polyhedron
%

P=Polyhedron('lb',0,'ub',1);

P.meshGrid;

end