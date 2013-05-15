function test_convexset_grid_02_pass
%
% two 1D sets
% 

x = sdpvar(1);
F1 = set(0<=x<=3);
F2 = set(x<=1) + set(0.3*x^2 <= 0.5);

Y1 = YSet(x,F1);
Y2 = YSet(x,F2);

Y = [Y1;Y2];


x = Y.grid(10);
end

