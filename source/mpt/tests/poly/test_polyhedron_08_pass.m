function test_polyhedron_08_pass
%
% polyhedron constructor test
% 
% 

% call using combined fields H, (A,b)
Polyhedron('H',[1 -2 3],'A',[1 2],'b',-10,'ub',[2;10]);

end
