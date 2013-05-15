function test_convexset_plot_01_fail
%
% 1D unbounded set not supported
%

x = sdpvar(1);
F = set(x<=1);

Y = YSet(x,F,sdpsettings('verbose',0));
Y.plot;

end
