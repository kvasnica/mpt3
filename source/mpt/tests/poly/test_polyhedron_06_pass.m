function test_polyhedron_06_pass
%
% polyhedron constructor test
% 
% 

% call polyhedron case insensitive
Polyhedron('he',[1 1]);
Polyhedron('v',[1; -2],'he',[0.5 -2/3]);