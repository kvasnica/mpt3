function test_yset_07_pass
%
% arrays of constraints
%

x = sdpvar(15,1);

F = (x<=1);
G = ( randn(3,15)*x==0 );


Y = YSet(x,[F;G]);

end
