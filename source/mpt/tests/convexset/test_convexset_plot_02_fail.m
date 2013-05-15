function test_convexset_plot_02_fail
%
% wrong color identifyier
%

x = sdpvar(2,1);
F1 = set( -1<= x <= 2)  + set( rand(1,2)*x<=3 );

Y1 = YSet(x,F1,sdpsettings('verbose',0));

h = Y1.plot('wire',true,'Marker','s','MarkerSize',5,'color','wrong color');

if isempty(h)
    error('Must return a handle.');
end

close all

end
