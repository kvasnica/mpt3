function test_yset_02_fail
%
% constructor test, wrong argument 2
%

x = sdpvar(1);
F = set(x<=1);

Y = YSet(x,0);

end
