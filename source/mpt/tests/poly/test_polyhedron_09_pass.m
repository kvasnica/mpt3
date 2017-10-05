function test_polyhedron_09_pass
%
% polyhedron constructor test
% 
% 

% lb and ub only
Polyhedron('lb',[-5; 8],'ub',[10 9999]);

end
