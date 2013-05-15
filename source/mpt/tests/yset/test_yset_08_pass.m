function test_yset_08_pass
%
% matrix variables
%

P = sdpvar(2,2);

A = [-1 2;-3 -4];
F = [P>=eye(2), A'*P+P*A <= -eye(2)];

S = YSet(P(:),F);


end
