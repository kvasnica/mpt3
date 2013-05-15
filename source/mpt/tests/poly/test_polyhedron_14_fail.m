function test_polyhedron_14_fail
%
% polyhedron constructor test
% 
% 

% dimension mismatch
Polyhedron('H',randn(3),'lb',1);
