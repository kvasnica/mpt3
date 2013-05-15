function test_convexset_fplot_06_fail
%
% 1D set no function
%

x = sdpvar(1);
F = set(-1<x<5) + set(0.5*x^2<0.2);

Y = YSet(x,F,sdpsettings('verbose',0));
Y.fplot;

end