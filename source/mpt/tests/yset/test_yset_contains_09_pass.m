function test_yset_contains_09_pass
%
% 3D test containment, x must be a row
%

x = sdpvar(1,2);

F1 = set(randn(2)*x'<=randn(2,1));
F2 = set(randn(2)*x'<=randn(2,1));

S1 = YSet(x,F1);
S2 = YSet(x,F2);

S = [S1,S2];

S.contains(randn(2,1));


end
