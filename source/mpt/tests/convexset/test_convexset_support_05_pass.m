function test_convexset_support_05_pass
%
% array of simple 2D sets (bounded, unbounded)
%

x = sdpvar(2,1);
F1 = [ 0.1*x'*x <=  1 ] + [ 2*x(1)-0.5*x(2) <= 0.5 ];
F2 = [ x <=  1 ] + [ randn(2)*x <= [0.5;0.1] ];
Y1 = YSet(x,F1);
Y2 = YSet(x,F2);
Y = [Y1; Y2];

v = 10*randn(2,1);

s = Y.support(v);


end
