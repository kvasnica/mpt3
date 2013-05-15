function test_convexset_fplot_07_fail
%
% 2D set no function
%

x = sdpvar(2,1);
F = set(-[1;3]<x<[5;4]) + set(0.5*x'*x<0.2);

Y = YSet(x,F,sdpsettings('verbose',0));
Y.fplot;

end