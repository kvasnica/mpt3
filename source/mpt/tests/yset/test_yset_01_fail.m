function test_yset_01_fail
%
% constructor test, wrong argument 1
%

x = sdpvar(1);
F = set(x<=1);

Y = YSet(0,F);

end
