function test_yset_06_pass
%
% convex set, but complex formulation
%

x = sdpvar(1);
y = sdpvar(1);
z = sdpvar(1);
F = [max(1,x)+max(y^2,z) <= 3, max(1,-min(x,y)) <= 5, norm([x;y],2) <= z];


Y = YSet([x,y,z],F);

end
