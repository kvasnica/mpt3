function test_yset_project_08_pass
%
% lifting in 3D
%

x = sdpvar(1);
y = sdpvar(1);
z = sdpvar(1);
F = [max(1,x)+max(y^2,z) <= 3, max(1,-min(x,y)) <= 5, norm([x;y],2) <= z];


Y = YSet([x,y,z],F);

%x=0;y=1;z=2
% the point is inside
z = [0,1,2];

s = Y.project(z);

if norm(s.dist)>1e-3
    error('This distance is 0 because the point is inside the set.');
end

%x=0; y=1; z=3;  -> first constraint violated
% the point is outside
v = [0;1;3];

h = Y.project(v);
if norm(h.dist-1)>1e-4
    error('This distance is one here.');
end


end
