function test_convexset_fplot_01_fail
%
% 1D set two functions, index out of bounds
%

x = sdpvar(1);
F = set(-1<x<5) + set(0.5*x^2<0.2);

Y = YSet(x,F,sdpsettings('verbose',0));
A = AffFunction(5.6,-1);
Q = QuadFunction(2,-3,0.5);

Y.addFunction(A);
Y.addFunction(Q);

h1 = Y.fplot(3);

end