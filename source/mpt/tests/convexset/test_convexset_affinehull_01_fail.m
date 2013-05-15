function test_convexset_affinehull_01_fail
%
% unbounded set
%

x = sdpvar(2,1);
S = YSet(x, set(x>0)+set(x(1)-x(2)<3), sdpsettings('solver','sedumi','verbose',0));

S.affineHull;

end