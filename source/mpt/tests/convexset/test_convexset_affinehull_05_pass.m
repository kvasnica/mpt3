function test_convexset_affinehull_05_pass
%
% empty YSet
%

x = sdpvar(2,1);
S = YSet(x, [-1<=x<=1; x<=-2; x==0], sdpsettings('solver','sedumi','verbose',0));

S.affineHull;

end
