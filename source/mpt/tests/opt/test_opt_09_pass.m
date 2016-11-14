function test_opt_09_pass
%
% opt constructor test
% 
% 

% include polyhedron
P = Polyhedron(randn(5,2),ones(5,1));
while P.isEmptySet
    P = Polyhedron(randn(5,2),ones(5,1));
end
problem = Opt('Ae',sparse(randn(1,2)),'be',rand(1,1),'pE',sparse(randn(1,3)),'P',P);


end