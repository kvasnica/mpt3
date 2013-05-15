function test_convexset_fplot_04_fail
%
% wrong identification of position
%

P = Polyhedron(randn(5,2));
A = AffFunction(randn(4,2),[0;1;0;2]);
B = AffFunction(randn(3,2),[0;-1;-2]);
P.addFunction(A,'a');
P.addFunction(B,'b');

P.fplot(2,[1:2],'Color','beige','alpha',0.5)

end