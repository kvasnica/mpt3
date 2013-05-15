function test_convexset_fplot_05_fail
%
% 1D set, unbounded - not supported
%

x = sdpvar(1);
F = set(x<5);

Y = YSet(x,F,sdpsettings('verbose',0));
A = AffFunction(5.6,-1);

Y.addFunction(A);
h1 = Y.fplot([],[],'polyhedron',true);

close all;

end