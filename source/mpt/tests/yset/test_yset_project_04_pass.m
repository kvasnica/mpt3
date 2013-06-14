function test_yset_project_04_pass
%
% 2D set, circle, the point is inside
%

x = sdpvar(1,2);

F = ( x*x' <= 1 );

S = YSet(x,F);

% the point is outside
z = [-0.5,-0.5];

s = S.project(z);

if norm(z-s.x)>1e-3
    error('Wrong the same because it is inside the set.');
end

if norm(s.dist)>1e-3
    error('Distance is 0 because the point is inside the set.');
end

end
