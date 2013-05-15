function test_yset_11_fail
%
% non-convex constraints must be detected even when modifying options
%

x = sdpvar(2,1);
F = [abs(abs(x(1)+1)+3) >= x(2), 0<=x(1)<=3];


Y = YSet(x,F,sdpsettings('verbose',1));

end
