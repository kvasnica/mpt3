function test_yset_05_fail
%
% non-convex constraints
%

x = sdpvar(2,1);
F = set(abs(x)>=1) + set(-2 <= x <= 2);

Y = YSet(x,F);

end
