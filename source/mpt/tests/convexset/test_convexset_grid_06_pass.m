function test_convexset_grid_06_pass
%
% Polyhedron grid
% 

P = Polyhedron(randn(11,2),4*ones(11,1));
x1 = P.grid(10);

Q = Polyhedron(randn(3));
x2 = Q.grid(10);

end

