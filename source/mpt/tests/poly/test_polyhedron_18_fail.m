function test_polyhedron_18_fail
%
% polyhedron constructor test
% 
% 

% dimension mismatch
Polyhedron(randn(4,5),randn(6,1));
