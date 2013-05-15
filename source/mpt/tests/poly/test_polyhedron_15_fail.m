function test_polyhedron_15_fail
%
% polyhedron constructor test
% 
% 

% dimension mismatch
Polyhedron('V',randn(3),'ub',ones(3,1),'H',[-1; 2]);
