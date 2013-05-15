function test_polyhedron_16_fail
%
% polyhedron constructor test
% 
% 

% lb/ub mismatch
Polyhedron('ub',1:3,'lb',[1 1 4]);
