function test_yset_contains_06_pass
%
% 3D test containment, x must be symmetric matrix, array
%

P = sdpvar(2,2);
A = [-1 2;-3 -4];
F = [P>=eye(2), A'*P+P*A <= -eye(2)];
S1 = YSet(P(:),F);
S2 = YSet(P(:),set(P>=0));
S = [S1,S2];

% point in both sets
t = S.contains([4; 1; 1; 2]);
assert(isequal(t, [true; true]));

% point in S2
t = S.contains([4; 1; 1; 1]);
assert(isequal(t, [false; true]));

end
