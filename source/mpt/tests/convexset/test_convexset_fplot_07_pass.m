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
Q = QuadFunction(rand(1));

Y.addFunction(A1,'A1');
Y.addFunction(A1,'A2');
Y.addFunction(A1,'Q');

% must get two handles
h = Y.fplot('A1');
assert(numel(h)==2);
h = Y.fplot('A2');
assert(numel(h)==2);
h = Y.fplot('Q');
assert(numel(h)==2);

close all


end
