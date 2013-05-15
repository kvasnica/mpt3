function test_yset_project_02_pass
%
% 1D set, point outside
%

x = sdpvar(1);
F = set(x'*x<=1);
S = YSet(x,F);

% the point is outside the set
s = S.project(2);

% the solution be 1
if norm(s.x-1,Inf)>1e-4
    error('The point must remain the same because it is inside the set.');
end

if norm(s.dist-1,Inf)>1e-4
    error('The distance is 1.');
end


end
