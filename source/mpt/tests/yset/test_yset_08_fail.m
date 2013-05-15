function test_yset_08_fail
%
% dimensions do not match
%

x = sdpvar(5,1);
y = sdpvar(2,1);

F = set(-1<=y<=1);
G = set( randn(5)*x<=ones(5,1) );


% ok
YSet([x;y],[F;G]);

% false
Y = YSet(y,G);

end
