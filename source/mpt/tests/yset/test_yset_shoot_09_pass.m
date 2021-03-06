function test_yset_shoot_09_pass
%
% lifting in 3D
%

x = sdpvar(1);
y = sdpvar(1);
z = sdpvar(1);
F = [max(1,x)+max(y^2,z) <= 3, max(1,-min(x,y)) <= 5, norm([x;y],2) <= z];


Y = YSet([x,y,z]',F);

%x=0;y=1;z=2

a1 = Y.shoot([0,1,2]');
if ~Y.contains(a1*[0,1,2]')
    error('This point must be contained in the set.');
end

%x=0; y=1; z=3;  -> first constraint violated
a2 = Y.shoot([0,1,3]');
if ~Y.contains(a2*[0,1,3]')
    error('This point is outside.');
end


end
