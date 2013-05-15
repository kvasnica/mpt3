function test_polyunion_02_fail
%
% Yset
%

x =sdpvar(2,1);
F = set(x<=0);
Y = YSet(x,F);

U = PolyUnion(Y);


end