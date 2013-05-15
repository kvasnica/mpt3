function test_convexset_removefunction_02_fail
%
% random polytope, 2 linear functions, index is out of range
%

P = Polyhedron(randn(5,1));
P.addFunction([AffFunction(-1,2);AffFunction(1,2)],{'b','a'});
P.removeFunction(3);

end