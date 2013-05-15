function test_yset_shoot_03_fail
%
% 3D test, x must be symmetric matrix, array
%

P = sdpvar(2,2);

A = [-1 2;-3 -4];
F = [P>=eye(2), A'*P+P*A <= -eye(2)];

S1 = YSet(P(:),F);

S2 = YSet(P(:),set(P>0));

S = [S1,S2];

a=S.shoot([4; 1; 2; 2]);


end
