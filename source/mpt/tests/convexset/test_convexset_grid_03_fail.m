function test_convexset_grid_03_fail
%
% unbounded polyhedron
% 

P = Polyhedron('lb',[0;-1;-2]);

x = P.grid(10);

end

