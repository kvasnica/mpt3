function test_yset_13_pass
%
% constructor test, wrong argument 1
%

x = sdpvar(1);
F = set(x<=1);

[worked, msg] = run_in_caller('Y = YSet(0,F); ');
assert(~worked);
asserterrmsg(msg,'YALMIP variables must be given as "sdpvar" object.');

end
