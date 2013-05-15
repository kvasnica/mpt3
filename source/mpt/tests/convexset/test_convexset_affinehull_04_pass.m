function test_convexset_affinehull_04_pass
%
% empty YSets
%

x = sdpvar(2,1);
S = YSet(x, set(x==1));

S.affineHull;

end