function test_convexset_grid_02_fail
%
% not feasible
% 

x = sdpvar(2,1);
F1 = set( x >0) + set( x < -1);

Y1 = YSet(x,F1);

x = Y1.grid(20);

end

