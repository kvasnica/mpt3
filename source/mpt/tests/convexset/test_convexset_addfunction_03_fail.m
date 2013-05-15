function test_convexset_addfunction_03_fail
%
% random polytope, same string again
%

P = Polyhedron(randn(5));
P.addFunction([AffFunction(-1,2);AffFunction(1,-2)],{'primal',''});
P.addFunction(AffFunction(2),{'primal'});

end