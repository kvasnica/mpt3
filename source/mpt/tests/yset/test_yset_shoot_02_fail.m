function test_yset_shoot_02_fail
%
% 3D test, x must be a double
%

x = sdpvar(1,2);

F1 = set(randn(2)*x'<=randn(2,1));

S1 = YSet(x,F1);

S1.shoot(x);


end
