function test_convexset_grid_07_pass
%
% Polyhedron array
% 

P(1) = Polyhedron(randn(11,2),4*ones(11,1));
P(2) = Polyhedron(randn(8,2));
P(3) = Polyhedron('lb',-rand(2,1),'ub',rand(2,1));

x = P.grid(20);
end

