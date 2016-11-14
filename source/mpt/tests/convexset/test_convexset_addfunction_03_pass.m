function test_convexset_addfunction_03_pass
%
% empty polyhedron, 1 simple functions with the name
%

P = Polyhedron;
P.addFunction(Function(@(x)x),'primal');

if ~P.hasFunction('primal')
    error('No name saved');
end

end
