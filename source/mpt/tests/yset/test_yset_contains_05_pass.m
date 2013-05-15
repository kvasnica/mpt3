function test_yset_contains_05_pass
%
% 3D test containment, LMI constraints
%

P = sdpvar(2,2);

A = [-1 2;-3 -4];
F = [P>=eye(2), A'*P+P*A <= -eye(2)];

S = YSet(P(:),F);

if S.contains(ones(4,1))
    error('The point must be outside of the set.');
end


if ~S.contains([4,1,1,2]')
    error('The point must be inside of the set.');
end


end
