function test_yset_23_pass
%
% non-convex constraints must be detected even when modifying options
%

x = sdpvar(2,1);
F = [abs(abs(x(1)+1)+3) >= x(2), 0<=x(1)<=3];


[worked, msg] = run_in_caller('Y = YSet(x,F,sdpsettings(''verbose'',1)); ');
assert(~worked);
asserterrmsg(msg,'Provided YALMIP constraints build non-convex set. Only convex set are allowed.');

end
