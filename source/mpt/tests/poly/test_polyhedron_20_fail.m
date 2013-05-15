function test_polyhedron_20_fail
%
% polyhedron constructor test
% 
% 

% too many polytopes
P = Polyhedron(randn(2,3),randn(3,1));
Polyhedron(P,P,P);
