function test_convexset_removefunction_02_pass
%
% empty polyhedron, add 2 simple functions in an array and remove them all
%

P = Polyhedron;
P.addFunction(Function(@(x) x), 'b');
P.addFunction(Function(@(x) x), 'a');
assert(length(P.Functions)==2);
assert(isequal(P.listFunctions, {'a', 'b'})); % sorted!
P.removeFunction('b');
assert(length(P.Functions)==1);
assert(isequal(P.listFunctions, {'a'}));
P.removeFunction('a');
assert(length(P.Functions)==0);

end
