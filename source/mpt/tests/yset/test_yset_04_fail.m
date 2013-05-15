function test_yset_04_fail
%
% constructor test, wrong argument 3- wrong format
%

x = sdpvar(1);
F = set(x<=1);

Y = YSet(x,F,struct('a',1,'b',2));

end
