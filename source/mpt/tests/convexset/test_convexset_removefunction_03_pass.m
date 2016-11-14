function test_convexset_removefunction_03_pass
%
% empty polyhedron, remove by the name
%

P = Polyhedron;
assert(isempty(P.Functions));
P.addFunction(Function(@(x)x),'primal');
P.addFunction(Function(@(x)x),'dual');
assert(length(P.Functions)==2);

P.removeFunction('primal');
assert(isequal(P.listFunctions, {'dual'}));
assert(length(P.Functions)==1);

end
