function test_yset_shoot_10_pass
%
% 3D test, x must be a double
%

x = sdpvar(1,2);

F1 = (randn(2)*x'<=randn(2,1));

S1 = YSet(x,F1);

[worked, msg] = run_in_caller('S1.shoot(x); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real vector.');


end
