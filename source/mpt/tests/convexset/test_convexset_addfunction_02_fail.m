function test_convexset_addfunction_02_fail
%
% random polytope, 2 same names of linear functions
%

P = Polyhedron(randn(5));
P.addFunction([AffFunction(-1,2);AffFunction(1,2)],{'primal','primal'});

end