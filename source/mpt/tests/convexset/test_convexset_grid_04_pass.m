function test_convexset_grid_04_pass
%
% set with one point
% 

x = sdpvar(2,1);
F1 = [ -1<= x <= 2;  x<=-1 ];

Y1 = YSet(x,F1);

x = Y1.grid(20);

end

