function test_convexset_removefunction_01_fail
%
% wrong indexing
%

P = Polyhedron;
P.addFunction([Function(@(x)x);Function(@(x)x.^2)],{'primal','objective'});
P.removeFunction(:)

end