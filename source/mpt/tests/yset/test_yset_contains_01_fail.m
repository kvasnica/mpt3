function test_yset_contains_01_fail
%
% 3D test containment, x must be symmetric matrix
%

P = sdpvar(2,2);

A = [-1 2;-3 -4];
F = [P>eye(2), A'*P+P*A <= -eye(2)];

S = YSet(P,F);

S.contains(randn(2));


end
