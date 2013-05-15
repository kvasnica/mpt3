function test_polyhedron_09_fail
%
% polyhedron constructor test
% 
% 

% do not accept NaN in He-representation
V = randn(3,5);
V(1,1) = NaN;
Polyhedron('He',V);
