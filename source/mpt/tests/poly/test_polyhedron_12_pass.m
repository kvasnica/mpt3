function test_polyhedron_12_pass
%
% polyhedron constructor test
% 
% 

% call using combined fields H, (A,b), He, (Ae, be)
Polyhedron('A',[10 2; -4 0.6],'b',[-5 8],'ub',[2;10],'He', [1 0 4],'Ae',[0 1],'be',-2);
