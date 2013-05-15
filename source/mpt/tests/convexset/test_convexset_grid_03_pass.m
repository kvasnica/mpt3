function test_convexset_grid_03_pass
%
% two 2D sets
% 

x = sdpvar(2,1);
F1 = set(x(1)<=1) + set(x(2)>=1) + set(0.3*x'*x <= 0.5);
F2 = set([9.1,-4.5]*x<=0) + set(0.1*x'*x <= 0.4);

Y1 = YSet(x,F1);
Y2 = YSet(x,F2);
Y=[Y1;Y2];

x = Y.grid(10);
end

