function test_yset_project_11_pass
%
% 3D test, x must be symmetric matrix, array
%

P = sdpvar(2,2);

A = [-1 2;-3 -4];
F = [P>=eye(2), A'*P+P*A <= -eye(2)];

S1 = YSet(P(:),F);

S2 = YSet(P(:),P>=0);

S = [S1,S2];

[worked, msg] = run_in_caller('s = S.project(randn(4,1)); ');
assert(~worked);
asserterrmsg(msg,'Inconsistent assignment');


end
