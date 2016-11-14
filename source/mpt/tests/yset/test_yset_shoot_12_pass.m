function test_yset_shoot_12_pass
%
% 3D test, x must be symmetric matrix and provided as vector
%

P = sdpvar(2,2);

A = [-1 2;-3 -4];
F = [P>=eye(2), A'*P+P*A <= -eye(2)];

[worked, msg] = run_in_caller('S = YSet(P,F); ');
assert(~worked);
asserterrmsg(msg,'Variables must be provided as vectors only.');
assert(~worked);
asserterrmsg(msg,'Variables must be provided as vectors only.');



end
