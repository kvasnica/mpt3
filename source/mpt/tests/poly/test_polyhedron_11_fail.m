function test_polyhedron_11_fail
%
% polyhedron constructor test
% 
% 

% do not accept NaN in ub
V = randn(3,1);
V(1) = NaN;
Polyhedron('ub',V);
