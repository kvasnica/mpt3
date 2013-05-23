function test_convexset_fplot_07_pass
%
% two 1D sets, two vector functions with names, plot based on the name and index
%

x = sdpvar(1);
F1 = [-1<=x<=5] + [0.5*x^2<=0.2];
Y1 = YSet(x,F1,sdpsettings('verbose',0));
F2 = [x<=0.3] + [-x^2>=-.4];
Y2 = YSet(x,F2,sdpsettings('verbose',0));

Y = [Y1,Y2];

A1 = AffFunction(rand(3,1),rand(3,1));
A2 = AffFunction(rand(4,1),rand(4,1));
Q = QuadFunction(rand(1,1,2),rand(2,1),rand(2,1));

% must get two handles
h = Y.addFunction(A1,'A1');
assert(numel(h)==2);
h = Y.addFunction(A2,'A2');
assert(numel(h)==2);
h = Y.addFunction(Q,'Q');
assert(numel(h)==2);

close all


end
