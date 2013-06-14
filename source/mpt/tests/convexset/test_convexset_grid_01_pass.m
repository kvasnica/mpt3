function test_convexset_grid_01_pass
%
% 1D set
% 

x = sdpvar(1);
F = [x<=1; 0.3*x^2 <= 0.5];

Y = YSet(x,F);

x = Y.grid(10);

end

