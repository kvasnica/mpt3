function test_polyhedron_08_fail
%
% polyhedron constructor test
% 
% 

% do not accept NaN in R-representation
V = randn(3,5);
V(1,1) = NaN;
Polyhedron('R',V);
