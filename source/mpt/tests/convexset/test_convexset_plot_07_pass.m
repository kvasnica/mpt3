function test_convexset_plot_07_pass
%
% two 3D sets (encountered difficulties when plotting 3D sets)
% sometimes Y2 cannot be seen and segmentation fault occurs when calling
% with
%  h = Y.plot('alpha',0.7,'Marker','x','MarkerSize',5,'grid',10);
%

x = sdpvar(3,1);
F1 = (0.3*x'*x <= 1.5);
F2 = [0.4*x'*x <= 2.5; -0.1*x(2)+2.3*x(3)<=0.5];

Y1 = YSet(x,F1,sdpsettings('verbose',0));
Y2 = YSet(x,F2,sdpsettings('verbose',0));
Y=[Y1;Y2];

h = Y.plot('alpha',0.7,'MarkerSize',5,'grid',10);


if isempty(h)
    error('Must return a handle.');
end
if numel(h)~=2
    error('Here should be 2 handles.');
end

close all

end
