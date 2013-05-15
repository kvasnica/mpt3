function test_convexset_addfunction_01_fail
%
% empty polyhedron, 2 simple functions concatenated in a cell 
%

P = Polyhedron;
P.addFunction({Function(@(x)x);Function(@(x)x.^2)},{'primal','objective'});

end