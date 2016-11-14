function test_convexset_affinehull_02_pass
%
% arrays are not supported
%

x = sdpvar(2,1);
S1 = YSet(x, [norm(x)<=1; x(1)-x(2)==0.2; [1 -0.5; 0.3, 0.8]*x<=[0.5;0.6]], sdpsettings('solver','sedumi','verbose',0));
S2 = YSet(x, [0.5*norm(x)<=1; 2*x(1)-5*x(2)==0.2; [-1 0.2; 0.1, -0.9]*x<=[0.8;0.5]], sdpsettings('solver','sedumi','verbose',0));
S=[S1,S2];

[~, msg] = run_in_caller('S.affineHull;');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

end
