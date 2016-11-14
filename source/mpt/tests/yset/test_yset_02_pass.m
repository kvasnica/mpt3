function test_yset_02_pass
%
% constructor test, options
%

x = sdpvar(1);
F = (x<=1);

Y = YSet(x,F,sdpsettings('solver','sedumi','verbose',0));

end
