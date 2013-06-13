function test_yset_14_pass
%
% constructor test, wrong argument 2
%

x = sdpvar(1);
F = set(x<=1);

[worked, msg] = run_in_caller('Y = YSet(x,0); ');
assert(~worked);
asserterrmsg(msg,'YALMIP constraints must be given as "lmi" object.');

end
