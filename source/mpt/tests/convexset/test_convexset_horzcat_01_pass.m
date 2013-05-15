function test_convexset_horzcat_01_pass
%
% 2 same objects
%

x = sdpvar(1);

F1 = set(x>=1);
F2 = set(x<=0);

Y1 = YSet(x,F1);
Y2 = YSet(x,F2);

Y = [Y1, Y2];


end
