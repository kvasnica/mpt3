function test_convexset_fplot_02_fail
%
% 1D set, three functions with names, plot based on the name and two
% indices
%

x = sdpvar(1);
F = set(-1<x<5) + set(0.5*x^2<0.2);

Y = YSet(x,F,sdpsettings('verbose',0));
A1 = AffFunction(rand(3,1),rand(3,1));
A2 = AffFunction(rand(4,1),rand(4,1));
Q = QuadFunction(rand(1,1,2),rand(2,1),rand(2,1));

Y.addFunction(A1,'A1');
Y.addFunction(A2,'A2');
Y.addFunction(Q,'Q');

% cannot plot both 2 and 3
h1 = Y.fplot({'A2','Q'},[2,3]);


end