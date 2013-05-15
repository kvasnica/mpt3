function test_yset_06_fail
%
% non-convex constraints
%

x = sdpvar(2,1);
F = [abs(abs(x(1)+1)+3) >= x(2), 0<=x(1)<=3];


Y = YSet(x,F);

end
