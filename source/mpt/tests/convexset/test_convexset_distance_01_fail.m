function test_convexset_distance_01_fail
%
% argument is not a number

x = sdpvar(2,1);
S = YSet(x, set(norm(x-[5;4])<1), sdpsettings('solver','sedumi','verbose',0));

S.distance(S);


end