function test_yset_project_03_pass
%
% 2D set, circle, the point is ouside
%

x = sdpvar(1,2);

F = ( x*x' <= 1 );

S = YSet(x,F);

% the point is outside
z = [-5,-5];

s = S.project(z);
v = [cos(pi*5/4), sin(pi*5/4)];

if norm(v-s.x)>1e-4
    error('Wrong point on the circle.');
end

end
