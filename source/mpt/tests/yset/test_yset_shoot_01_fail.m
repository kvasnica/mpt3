function test_yset_shoot_01_fail
%
% 3D test, x must be symmetric matrix
%

P = sdpvar(2,2);

A = [-1 2;-3 -4];
F = [P>=eye(2), A'*P+P*A <= -eye(2)];

S = YSet(P,F);

S.shoot(randn(2));


end
