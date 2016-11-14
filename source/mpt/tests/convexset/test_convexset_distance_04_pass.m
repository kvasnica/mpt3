function test_convexset_distance_04_pass
%
% argument is not a number

x = sdpvar(2,1);
S = YSet(x, norm(x-[5;4])<=1, sdpsettings('solver','sedumi','verbose',0));

[worked, msg] = run_in_caller('S.distance(S); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real vector.');


end