function test_yset_contains_10_pass
%
% 3D test containment, x must be symmetric matrix
%

P = sdpvar(2,2);

A = [-1 2;-3 -4];
F = [P>=eye(2), A'*P+P*A <= -eye(2)];

S = YSet(P(:),F);
[worked, msg] = run_in_caller('S.contains(randn(2)); ');
assert(~worked);
asserterrmsg(msg,'The point must have 4 rows.');


end
