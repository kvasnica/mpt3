function test_polyhedron_11_pass
%
% polyhedron constructor test
% 
% 

% call using case sensitive fields
Polyhedron('H',[1 -2],'HE',[1 2],'LB',-10,'UB',2,'Data','data');

end
