function test_polyhedron_fplot_03_fail
%
% 3D polyhedron, affine function
%

P = Polyhedron('V',randn(6,3));

L = AffFunction(randn(5,3));
P.addFunction(L);


P.fplot;


end