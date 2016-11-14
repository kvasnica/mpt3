function test_yset_15_pass
%
% constructor test, wrong argument 3
%

x = sdpvar(1);
F = (x<=1);

[worked, msg] = run_in_caller('Y = YSet(x,F,0); ');
assert(~worked);
asserterrmsg(msg,'Options must be provided in a struct format, given by YALMIP "sdpsettings".');

end
