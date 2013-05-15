function test_yset_07_pass
%
% arrays of constraints
%

x = sdpvar(15,1);

F = set(x<=1);
G = set( randn(3,15)*x==0 );


Y = YSet(x,[F;G]);

end
