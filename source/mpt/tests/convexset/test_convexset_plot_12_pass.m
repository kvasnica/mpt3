function test_convexset_plot_12_pass
%
% 1D unbounded set not supported
%

x = sdpvar(1);
F = (x<=1);

Y = YSet(x,F,sdpsettings('verbose',0));
Y.plot;

end
