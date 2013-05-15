function test_convexset_grid_01_fail
%
% unbounded set
% 

x = sdpvar(2,1);
F1 = set( x >0); 

Y1 = YSet(x,F1);

x = Y1.grid(20);

end

