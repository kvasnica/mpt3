function test_convexset_plot_05_pass
%
% 2D set
%

x = sdpvar(2,1);
F = [x(1)<=1; x(2)>=1; 0.3*x'*x <= 0.5];

Y = YSet(x,F);
Y.plot('linestyle','-.','LineWidth',3);

h = Y.plot('color','red');

if isempty(h)
    error('Must return a handle.');
end

close all

end
