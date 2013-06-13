function test_convexset_affinehull_06_pass
%
% unbounded set
%

x = sdpvar(2,1);
S = YSet(x, [x>=0; x(1)-x(2)<=3], sdpsettings('solver','sedumi','verbose',0));

[worked, msg] = run_in_caller('S.affineHull; ');
assert(~worked);
asserterrmsg(msg,'Can only compute the affine hull of bounded ConvexSets');

end