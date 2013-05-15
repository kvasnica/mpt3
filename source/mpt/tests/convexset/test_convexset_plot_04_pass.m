function test_convexset_plot_04_pass
%
% two 1D sets, no handle and handle, pick linewidth, linestyle
%

x = sdpvar(1);
F1 = set(0<=x<=3);
F2 = set(x<=1) + set(0.3*x^2 <= 0.5);

Y1 = YSet(x,F1,sdpsettings('verbose',0));
Y2 = YSet(x,F2,sdpsettings('verbose',0));

Y = [Y1;Y2];

Y.plot('linestyle','-.','LineWidth',3);

h = Y.plot('color','red');

if isempty(h)
    error('Must return a handle.');
end
if numel(h)~=2
    error('Here must be two handles on the output.');
end

close all

end
