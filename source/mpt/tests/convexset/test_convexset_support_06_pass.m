function test_convexset_support_06_pass
%
% array of random polyhedra in 5D
%

x = sdpvar(5,1);
F1 = (randn(17,5)*x <= ones(17,1));
F2 = [(randn(54,5)*x <= 2*ones(54,1)) ; (randn(3,5)*x==0.2*rand(3,1))];

Y = [YSet(x,F1), YSet(x,F2)];

v = 10*randn(5,1);

s = Y.support(v);

end