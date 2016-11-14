function test_yset_project_06_pass
%
% LMI constraints
%

P = sdpvar(2,2);

A = [-1 2;-3 -4];
F = [P>=eye(2), A'*P+P*A <= -eye(2)];

S = YSet(P(:),F);

% the point is outside
z = ones(4,1);

s = S.project(z);
if ~S.contains(s.x)
    error('The point must be on the edge of the set.');
end

% slight perturbation moves the point outside
if S.contains(s.x+[-0.0001;0;0;0])
    error('The point must be outside of the set.');
end


end
