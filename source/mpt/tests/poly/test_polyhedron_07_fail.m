function test_polyhedron_07_fail
%
% polyhedron constructor test
% 
% 

% do not accept NaN in H-representation
V = randn(3,5);
V(1,1) = NaN;
Polyhedron('H',V);
