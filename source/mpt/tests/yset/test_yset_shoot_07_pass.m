function test_yset_shoot_07_pass
%
% 3D test shooting, x must be symmetric matrix, array
%

P = sdpvar(2,2);

A = [-1 2;-3 -4];
F = [P>=eye(2), A'*P+P*A <= -eye(2)];

S1 = YSet(P(:),F);

S2 = YSet(P(:),P>=0);

S = [S1,S2];

a = S.shoot([4;1;1;2]);

if any(~isinf(a))
    error('Unbounded in this direction of.');
end


end
