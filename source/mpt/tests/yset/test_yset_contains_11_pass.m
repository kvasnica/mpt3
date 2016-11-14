function test_yset_contains_11_pass
%
% 3D test containment, x must be a double
%

x = sdpvar(1,2);

F1 = [randn(2)*x'<=randn(2,1)];

S1 = YSet(x,F1);

[worked, msg] = run_in_caller('S1.contains(x); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real matrix.');


end
