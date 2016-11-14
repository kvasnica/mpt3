function test_yset_project_01_pass
%
% 1D set, point inside
%

x = sdpvar(1);
F = (x'*x<=1);
S = YSet(x,F);

% the point is inside the set
s = S.project(0.5);

% the solution must remain the same
if norm(s.x-0.5,Inf)>1e-4
    error('The point must remain the same because it is inside the set.');
end

if norm(s.dist,Inf)>1e-4
    error('The distance is 0 because the point lies inside the set.');
end


end
