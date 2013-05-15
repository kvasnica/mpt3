function test_yset_07_fail
%
% dimensions do not match
%

x = sdpvar(15,1);

F = set(x<=1);
G = set( randn(3,15)*x==0 );


YSet(x(3:4),[F;G]);

end
