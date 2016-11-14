function test_convexset_removefunction_01_pass
%
% empty polyhedron, one add, one remove
%

P = Polyhedron;
P.addFunction(Function(@(x)x), 'f');
assert(length(P.Functions)==1);
P.removeFunction('f');

assert(isempty(P.Functions));

end
