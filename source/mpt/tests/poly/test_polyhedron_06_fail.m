function test_polyhedron_06_fail
%
% polyhedron constructor test
% 
% 

% do not accept NaN in V-representation
V = randn(3,5);
V(1,1) = NaN;
Polyhedron(V);
