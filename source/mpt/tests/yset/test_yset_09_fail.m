function test_yset_09_fail
%
% 3D matrices not allowed
%

x = sdpvar(5,2,3);

F = set(x<=1);

% false
Y = YSet(x,F);

end
