function test_convexset_removefunction_03_fail
%
% random polytope, 3 linear functions, the string is not there
%

P = Polyhedron(randn(8,1));
P.addFunction([AffFunction(2),AffFunction(1),AffFunction(0,-1)],{'x','y','z'});
P.removeFunction('xx');

end