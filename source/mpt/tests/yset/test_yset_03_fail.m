function test_yset_03_fail
%
% constructor test, wrong argument 3
%

x = sdpvar(1);
F = set(x<=1);

Y = YSet(x,F,0);

end
