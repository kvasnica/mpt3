function test_yset_01_pass
%
% constructor test, no options
%

x = sdpvar(1);
F = set(x<=1);

Y = YSet(x,F);

end
