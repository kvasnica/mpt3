function test_convexset_affinehull_05_pass
%
% empty YSet
%

x = sdpvar(2,1);
S = YSet(x, set(-1<=x<=1)+set(x<=-2)+set(x==0), sdpsettings('solver','sedumi','verbose',0));

S.affineHull;

end
