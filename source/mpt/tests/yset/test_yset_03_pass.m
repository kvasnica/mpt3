function test_yset_03_pass
%
% changing options
%

x = sdpvar(1);
F = set(x<=1);

Y = YSet(x,F,sdpsettings('solver','sedumi','verbose',0));

end
