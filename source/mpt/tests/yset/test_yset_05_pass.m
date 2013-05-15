function test_yset_05_pass
%
% non-convex constraints that are convexified by lifting
%

x = sdpvar(2,1);
F = [-5 <= x(1) <= 5,x(2) == -(x(1)-2).^2];

Y = YSet(x,F);

end