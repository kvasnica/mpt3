function test_polyhedron_10_fail
%
% polyhedron constructor test
% 
% 

% do not accept NaN in lb
V = randn(3,1);
V(1) = NaN;
Polyhedron('lb',V);
