function test_yset_17_pass
%
% non-convex constraints
%

x = sdpvar(2,1);
F = set(abs(x)>=1) + set(-2 <= x <= 2);

[worked, msg] = run_in_caller('Y = YSet(x,F); ');
assert(~worked);
asserterrmsg(msg,'Provided YALMIP constraints build non-convex set. Only convex set are allowed.');

end
