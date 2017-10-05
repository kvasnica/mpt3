function test_polyhedron_04_pass
%
% polyhedron constructor test
% 
% 

% call polyhedron twice on random data
Polyhedron(Polyhedron(randn(randi(5,1),randi(5,1))));

end
