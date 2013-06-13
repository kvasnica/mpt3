function test_yset_16_pass
%
% constructor test, wrong argument 3- wrong format
%

x = sdpvar(1);
F = set(x<=1);

[worked, msg] = run_in_caller('Y = YSet(x,F,struct(''a'',1,''b'',2)); ');
assert(~worked);
asserterrmsg(msg,'The field "solver" is missing in the options format.');

end
