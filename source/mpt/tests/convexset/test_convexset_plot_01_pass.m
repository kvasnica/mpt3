function test_convexset_plot_01_pass
%
% 1D set, no handle and handle
%

x = sdpvar(1);
F = [-1<=x<=5; 0.5*x^2<=0.2];

Y = YSet(x,F,sdpsettings('verbose',0));
Y.plot;

h = Y.plot;

if isempty(h)
    error('Must return a handle.');
end
close all

end
