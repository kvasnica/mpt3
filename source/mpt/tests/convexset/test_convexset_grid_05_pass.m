function test_convexset_grid_05_pass
%
% 3D set
% 

x = sdpvar(3,1);
F1 = set(0.3*x'*x <= 0.7);

Y1 = YSet(x,F1);
x = Y1.grid(7);

end

