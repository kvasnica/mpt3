function test_polyhedron_17_fail
%
% polyhedron constructor test
% 
% 

% no cells please
Polyhedron('H',{[1 2]},'HE',[1 3]);
