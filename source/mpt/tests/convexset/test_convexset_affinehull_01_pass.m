function test_convexset_affinehull_01_pass
%
% regular YSet based on the example
%

x = sdpvar(2,1);
S = YSet(x, [norm(x)<=1; x(1)-x(2)==0.2; [1 -0.5; 0.3, 0.8]*x<=[0.5;0.6]], sdpsettings('solver','sedumi','verbose',0));
S.affineHull;

end
